<?php
class ModelUvdeskUvdesk extends Model {

	public function getCustomer() {
		$url = 'customers.json?';
		$url .= 'email=' . $this->customer->getEmail();

		$customer = $this->callApi($url);
		return $customer;
	}

	public function getTickets($data) {
		$url = 'tickets.json?';

		$url .= 'customer=' . $data['customer_id'];

		if (isset($data['page']) && $data['page']) {
			$url .= '&page=' . $data['page'];
		}

		if (isset($data['status']) && $data['status']) {
			$url .= '&status=' . $data['status'];
		}

		if (isset($data['sort']) && $data['sort']) {
			$url .= '&sort=' . $data['sort'];
		}

		if (isset($data['search']) && $data['search']) {
			$url .= '&search=' . $data['search'];
		}

		if (isset($data['order']) && $data['order']) {
			$url .= '&direction=' . $data['order'];
		}

		$tickets = $this->callApi($url);
		return $tickets;
	}

	public function getTicket($ticket_id) {
		// Returns ticket
		$url = 'ticket/' . $ticket_id . '.json';

		$ticket = $this->callApi($url);
		return $ticket;
	}

	public function getTicketTypes() {
		$url = 'ticket-types.json?isActive=1';

		$types = $this->callApi($url);
		return $types;
	}

	private function callApi($added_url = '') {
		$company_domain = $this->config->get('uvdesk_company_domain');
		$url = 'https://' . $company_domain . '.uvdesk.com/en/api/';
		$url .= $added_url;

		$access_token = $this->config->get('uvdesk_access_token');
		$ch = curl_init($url);
		$headers = array(
			'Authorization: Bearer ' . $access_token,
		);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_HEADER, true);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		$output = curl_exec($ch);
		$info = curl_getinfo($ch);
		$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
		$headers = substr($output, 0, $header_size);
		$response = substr($output, $header_size);

		if($info['http_code'] == 200) {
			curl_close($ch);
			return json_decode($response);
		} else if($info['http_code'] == 404) {
			curl_close($ch);
			return array(
				'error' => 1,
				'description' => 'Error, resource not found (http-code: 404)'
				);
		} else {
			curl_close($ch);
			return json_decode($response);
		}
		curl_close($ch);
		exit();
	}

	public function getThreads($ticket_id, $page) {
		$url = 'ticket/' . $ticket_id . '/threads.json';

		if ($page) {
			$url .= '?page=' . $page;
		}

		$threads = $this->callApi($url);
		return $threads;
	}

	public function addThread($ticket_id, $reply) {
		$url = 'ticket/' . $ticket_id . '/threads.json';

		$lineEnd = "\r\n";
		$mime_boundary = md5(time());
		$data = '--' . $mime_boundary . $lineEnd;
		$data .= 'Content-Disposition: form-data; name="reply"' . $lineEnd . $lineEnd;
		$data .= $reply . $lineEnd;
		$data .= '--' . $mime_boundary . $lineEnd;
		$data .= 'Content-Disposition: form-data; name="threadType"' . $lineEnd . $lineEnd;
		$data .= "reply" . $lineEnd;
		$data .= '--' . $mime_boundary . $lineEnd;

		// act as type (type of user making reply to differentiate whether the user is customer or agent)
		$data .= 'Content-Disposition: form-data; name="actAsType"' . $lineEnd . $lineEnd;
		$data .= "customer" . $lineEnd;
		$data .= '--' . $mime_boundary . $lineEnd;

		// act as email (email of user making reply to differentiate whether the reply is made by the customer or collaborator)
		$data .= 'Content-Disposition: form-data; name="actAsEmail"' . $lineEnd . $lineEnd;
		$data .= $this->customer->getEmail() . $lineEnd;
		$data .= '--' . $mime_boundary . $lineEnd;

		// attachements

		if (isset($this->request->files['attachment']) && $this->request->files['attachment']) {
			foreach ($this->request->files['attachment']['name'] as $key => $file) {
				if ($file) {
					$fileType = $this->request->files['attachment']['type'][$key];
					$fileName = $this->request->files['attachment']['name'][$key];
					$fileTmpName = $this->request->files['attachment']['tmp_name'][$key];

					$data .= 'Content-Disposition: form-data; name="attachments[]"; filename="' . $fileName . '"' . $lineEnd;
					$data .= "Content-Type: $fileType" . $lineEnd . $lineEnd;
					$data .= file_get_contents($fileTmpName) . $lineEnd;
					$data .= '--' . $mime_boundary . $lineEnd;
				}
			}
		}

		if (isset($this->request->files['files']['tmp_name']) && $this->request->files['files']['tmp_name']) {
			$data .= 'Content-Disposition: form-data; name="attachments[]"; filename="' . $this->request->files['files']['name'] . '"' . $lineEnd;
			$data .= "Content-Type: " . $this->request->files['files']['type'] . $lineEnd . $lineEnd;
			$data .= file_get_contents($this->request->files['files']['tmp_name']) . $lineEnd;
			$data .= '--' . $mime_boundary . $lineEnd;
		}

		$data .= "--" . $mime_boundary . "--" . $lineEnd . $lineEnd;

		$response = $this->postApi($url, $data, 'POST', $mime_boundary);
		return $response;
	}

	public function addCollaborator($ticket_id, $email) {
		$url = 'ticket/' . $ticket_id . '/collaborator.json';

		$data = array(
			'email' => $email
			);

		$response = $this->postApi($url, $data, 'POST');
		return $response;
	}

	public function removeCollaborator($ticket_id, $col_id) {
		$url = 'ticket/' . $ticket_id . '/collaborator.json';

		$data = array(
			'collaboratorId' => $col_id
			);

		$response = $this->postApi($url, $data, 'DELETE');
		return $response;
	}

	public function createTicket($data) {
		$url = 'tickets.json';

		$data = array(
			'name'    => $data['name'],
			'from'    => $data['email'],
			'subject' => $data['subject'],
			'reply'   => $data['message'],
			'type'    => $data['type']
			);

		$ticket = $this->postApi($url, $data, 'POST');
		return $ticket;
	}

	protected function postApi($added_url = '', $data, $custom = '', $mime_boundary = '') {
		$access_token = $this->config->get('uvdesk_access_token');
		// ticket url
		$company_domain = $this->config->get('uvdesk_company_domain');
		$url = 'https://' . $company_domain . '.uvdesk.com/en/api/';
		$url .= $added_url;

		if (!$mime_boundary) {
			$data = json_encode($data);
		}

		$ch = curl_init($url);

		if ($mime_boundary) {
			$headers = array(
				"Authorization: Bearer ".$access_token,
				"Content-type: multipart/form-data; boundary=" . $mime_boundary,
			);
		} else {
			$headers = array(
				'Authorization: Bearer ' . $access_token,
				'Content-type: application/json'
			);
		}

		curl_setopt($ch, CURLOPT_POST, true);
		curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
		curl_setopt($ch, CURLOPT_HEADER, true);
		curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);

		if ($custom) {
			curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $custom);
		}

		$server_output = curl_exec($ch);
		$info = curl_getinfo($ch);
		$header_size = curl_getinfo($ch, CURLINFO_HEADER_SIZE);
		$headers = substr($server_output, 0, $header_size);
		$response = substr($server_output, $header_size);
		if($info['http_code'] == 200 || $info['http_code'] == 201) {
			curl_close($ch);
			return json_decode($response);
		} elseif($info['http_code'] == 400) {
			curl_close($ch);
			return json_decode($response);
		} elseif($info['http_code'] == 404) {
			echo "Error, resource not found (http-code: 404) \n";
		} else {
			echo "Error, HTTP Status Code : " . $info['http_code'] . "\n";
			echo "Headers are ".$headers;
			echo "Response are ".$response;
		}
		curl_close($ch);
		exit();
	}
}
