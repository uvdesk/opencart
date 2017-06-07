<?php
class ModelUvdeskUvdesk extends Model {

	public function getTickets($data = array()) {
		// Return tickets
		$url = 'tickets.json?';

		$url .= 'page=' . $data['page'];

		if (isset($data['tab']) && $data['tab']) {
			$url .= '&status=' . $data['tab'];
		}

		if (isset($data['label']) && $data['label']) {
			$url .= '&'. $data['label'];
		}

		if (isset($data['custom_label']) && $data['custom_label']) {
			$url .= '&label='. $data['custom_label'];
		}

		if (isset($data['search']) && $data['search']) {
			$url .= '&search='. $data['search'];
		}

		if (isset($data['customer']) && $data['customer']) {
			$url .= '&customer='. $data['customer'];
		}

		if (isset($data['agent']) && $data['agent']) {
			$url .= '&agent='. $data['agent'];
		}

		if (isset($data['priority']) && $data['priority']) {
			$url .= '&priority='. $data['priority'];
		}

		if (isset($data['group']) && $data['group']) {
			$url .= '&group='. $data['group'];
		}

		if (isset($data['team']) && $data['team']) {
			$url .= '&team='. $data['team'];
		}

		if (isset($data['type']) && $data['type']) {
			$url .= '&type='. $data['type'];
		}

		if (isset($data['tag']) && $data['tag']) {
			$url .= '&tag='. $data['tag'];
		}

		if (isset($data['mailbox']) && $data['mailbox']) {
			$url .= '&mailbox='. $data['mailbox'];
		}

		if (isset($data['sort']) && $data['sort']) {
			$url .= '&sort=' . $data['sort'];
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

	public function deleteTickets($ids) {
		$url = 'tickets.json';

		$data = array(
			'ids'      => $ids
			);

		$response = $this->postApi($url, $data, 'DELETE');
		return $response;
	}

	public function getCustomers($name) {
		$url = 'customers.json?search=' . $name;

		$ticket = $this->callApi($url);
		return $ticket;
	}

	public function getMembers($name) {
		$url = 'members.json?fullList=1';//search=' . $name;

		$ticket = $this->callApi($url);
		return $ticket;
	}

	public function getTags($name) {
		$url = 'tags.json?search=' . $name;

		$ticket = $this->callApi($url);
		return $ticket;
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

		$data .= "--" . $mime_boundary . "--" . $lineEnd . $lineEnd;

		$response = $this->postApi($url, $data, 'POST', $mime_boundary);
		return $response;
	}

	public function assignAgent($ticket_id, $member_id) {
		$url = 'ticket/' . $ticket_id . '/agent.json';

		$data = array(
			'id'      => $member_id
			);

		$response = $this->postApi($url, $data, 'PUT');
		return $response;
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
