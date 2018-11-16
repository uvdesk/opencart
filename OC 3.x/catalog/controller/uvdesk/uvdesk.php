<?php
class ControllerUvdeskUvdesk extends Controller {
	private $error = array();

	public function index() {
		$data = $this->load->language('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');

		if (!$this->customer->getId() || !$this->config->get('module_uvdesk_status')) {
			$this->response->redirect($this->url->link('account/login', '', true));
		}

		$this->document->setTitle($this->language->get('heading_title'));

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_uvdesk'),
			'href' => $this->url->link('uvdesk/uvdesk', '', true)
		);

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		if (isset($this->session->data['uvdesk_customer_id'])) {
			$data['isTicketCustomer'] = true;
		} else {
			$customer = $this->model_uvdesk_uvdesk->getCustomer();

			if (isset($customer->customers[0])) {
				$data['isTicketCustomer'] = true;

				$this->session->data['uvdesk_customer_id'] = $customer->customers[0]->id;
			} else {
				$data['isTicketCustomer'] = false;
			}
		}

		$data['ticket_url'] = $this->url->link('uvdesk/uvdesk/view', '', true);
		$data['create_ticket'] = $this->url->link('uvdesk/uvdesk/create', '', true);

		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');

		$this->response->setOutput($this->load->view('uvdesk/uvdesk_list', $data));
	}

	public function create() {
		$data = $this->load->language('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');

		if (!$this->config->get('module_uvdesk_status')) {
			$this->response->redirect($this->url->link('account/account', '', true));
		}

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$data = $this->request->post;

			if ($this->customer->getId()) {
				$data['name'] = $this->customer->getFirstName() . ' ' . $this->customer->getLastName();
				$data['email'] = $this->customer->getEmail();
			}
			$ticket = $this->model_uvdesk_uvdesk->createTicket($data);

			$this->session->data['success'] = $ticket->message;
			if ($this->customer->getId()) {
				$this->response->redirect($this->url->link('uvdesk/uvdesk/view', 'id=' . $ticket->id, true));
			} else {
				$this->response->redirect($this->url->link('account/login', '', true));
			}
		}

		$errors = array(
			'warning',
			'name',
			'email',
			'type',
			'subject',
			'message',
			);

		foreach ($errors as $error) {
			if (isset($this->error[$error])) {
				$data['error_' . $error] = $this->error[$error];
			} else {
				$data['error_' . $error] = '';
			}
		}

		if (isset($this->request->post['type'])) {
			$data['type'] = $this->request->post['type'];
		} else {
			$data['type'] = '';
		}

		if (isset($this->request->post['subject'])) {
			$data['subject'] = $this->request->post['subject'];
		} else {
			$data['subject'] = '';
		}

		if (isset($this->request->post['message'])) {
			$data['message'] = $this->request->post['message'];
		} else {
			$data['message'] = '';
		}

		$data['isCustomer'] = $this->customer->getId();

		$this->document->setTitle($this->language->get('heading_create'));

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_uvdesk'),
			'href' => $this->url->link('uvdesk/uvdesk', '', true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_create'),
			'href' => $this->url->link('uvdesk/uvdesk/create', '', true)
		);

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		$data['types'] = array();

		$types = $this->model_uvdesk_uvdesk->getTicketTypes();

		if (isset($types->types) && $types->types) {
			foreach ($types->types as $type) {
				$data['types'][] = array(
					'name'  => $type->name,
					'value' => $type->id
					);
			}
		}

		$data['action'] = $this->url->link('uvdesk/uvdesk/create', '', true);
		// $data['ticket_url'] = $this->url->link('uvdesk/uvdesk/view', '', true);

		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');

		$this->response->setOutput($this->load->view('uvdesk/uvdesk_form', $data));
	}

	public function view() {
		$data = $this->load->language('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');

		if (!$this->customer->getId() || !$this->config->get('module_uvdesk_status')) {
			$this->response->redirect($this->url->link('account/login', '', true));
		}

		// $this->document->setTitle($this->language->get('heading_title'));
		$this->document->addScript('admin/view/javascript/summernote/summernote.js');
		$this->document->addStyle('admin/view/javascript/summernote/summernote.css');
		$this->document->addScript('catalog/view/javascript/jquery/datetimepicker/moment.js');
		$this->document->addScript('catalog/view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.js');
		$this->document->addStyle('catalog/view/javascript/jquery/datetimepicker/bootstrap-datetimepicker.min.css');

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/home')
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_uvdesk'),
			'href' => $this->url->link('uvdesk/uvdesk', '', true)
		);

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];
			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		if (isset($this->session->data['warning'])) {
			$data['warning'] = $this->session->data['warning'];
			unset($this->session->data['warning']);
		} else {
			$data['warning'] = '';
		}

		if (isset($this->request->get['id']) && $this->request->get['id']) {
			$ticket = $this->model_uvdesk_uvdesk->getTicket($this->request->get['id']);

			$data['id'] = $this->request->get['id'];
			$data['thread_id'] = $ticket->ticket->id;
			$data['ticket'] = $ticket->ticket;
			$data['ticketTotalThreads'] = $ticket->ticketTotalThreads;
			$data['ticket_reply'] = $ticket->createThread->reply;
			$data['attachments'] = $ticket->createThread->attachments;
			if (isset($ticket->ticket->customer->id) && isset($this->session->data['uvdesk_customer_id']) && ($ticket->ticket->customer->id == $this->session->data['uvdesk_customer_id'])) {
				$this->document->setTitle($ticket->ticket->subject);
			} else {
				$this->response->redirect($this->url->link('account/login', '', true));
			}
		}

		if (!isset($data['thread_id'])) {
			$data['thread_id'] = 0;
		}

		if (!isset($data['id'])) {
			$data['id'] = 0;
		}

		$data['add_reply'] = $this->url->link('uvdesk/uvdesk/addReply', '', true);
		$data['attachment_url'] = $this->url->link('uvdesk/uvdesk/download', 'attachment=', true);

		$data['column_left'] = $this->load->controller('common/column_left');
		$data['column_right'] = $this->load->controller('common/column_right');
		$data['content_top'] = $this->load->controller('common/content_top');
		$data['content_bottom'] = $this->load->controller('common/content_bottom');
		$data['footer'] = $this->load->controller('common/footer');
		$data['header'] = $this->load->controller('common/header');

		$this->response->setOutput($this->load->view('uvdesk/uvdesk', $data));
	}

	public function getTickets() {
		$json = array();
		$this->load->language('uvdesk/uvdesk');

		if (isset($this->session->data['uvdesk_customer_id'])) {
			$json['tickets'] = array();
			$this->load->model('uvdesk/uvdesk');

			if (isset($this->request->post['page']) && $this->request->post['page']) {
				$page = $this->request->post['page'];
			} else {
				$page = 1;
			}

			if (isset($this->request->post['status']) && $this->request->post['status']) {
				$status = $this->request->post['status'];
			} else {
				$status = 0;
			}

			if (isset($this->request->post['order']) && $this->request->post['order']) {
				$order = $this->request->post['order'];
			} else {
				$order = 'ASC';
			}

			if (isset($this->request->post['search']) && $this->request->post['search']) {
				$search = $this->request->post['search'];
			} else {
				$search = '';
			}

			if (isset($this->request->post['sort_by']) && $this->request->post['sort_by']) {
				$sort = $this->request->post['sort_by'];
			} else {
				$sort = 't.id';
			}

			$filter_data = array(
				'sort'  => $sort,
				'order' => $order,
				'page'  => $page,
				'status'	=> $status,
				'search' => $search,
				'customer_id' => $this->session->data['uvdesk_customer_id']
			);

			$tickets = $this->model_uvdesk_uvdesk->getTickets($filter_data);

			$json['current_page'] = $tickets->pagination->current;
			$json['last_page'] = $tickets->pagination->last;

			$ticket_total = $tickets->pagination->totalCount;

			$items_on_page = $tickets->pagination->numItemsPerPage;

			$results = $tickets->tickets;

			foreach ($results as $result) {
				$json['tickets'][] = array(
					'ticket_id' => $result->incrementId,
					'priority'  => $result->priority ? array(
						'name'  => $result->priority->name,
						'color' => $result->priority->color
						) : array(
						'name'  => '',
						'color' => ''
						),
					'subject'    => (strlen($result->subject) < 50) ? $result->subject : utf8_substr($result->subject, 0, 50) . '...',
					'date_added' => $result->formatedCreatedAt,
					'threads'    => $result->totalThreads,
					'attachments' => $result->hasAttachments,
					'status'	=> 	$result->status->name,
					'agent'      => $result->agent ? $result->agent->name : '',
					'view'       => $this->url->link('uvdesk/uvdesk/view', 'ticket_id=' . $result->incrementId . '', true)
				);
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function getThreads() {
		$json = array();

		if (isset($this->request->post['id']) && $this->request->post['id']) {
			$this->load->model('uvdesk/uvdesk');

			if (isset($this->request->post['page']) && $this->request->post['page']) {
				$page = $this->request->post['page'];
			} else {
				$page = 0;
			}

			$threads = $this->model_uvdesk_uvdesk->getThreads($this->request->post['id'], $page);

			if (isset($threads->threads) && $threads->threads) {
				$json['total'] = $threads->pagination->totalCount;
				$json['last_page'] = $threads->pagination->last;
				$json['current_page'] = $threads->pagination->current;
				foreach ($threads->threads as $thread) {
					$attachments = array();
					if (isset($thread->attachments) && $thread->attachments) {
						foreach ($thread->attachments as $attachment) {
							$attachments[] = array(
								'id'  => $attachment->id
								);
						}
					}
					$json['threads'][] = array(
						'thread_id'    => $thread->id,
						'date_added'   => $thread->formatedCreatedAt,
						'user_type'    => (($thread->userType == 'agent') ? 'Agent' : ''),
						'name'         => ($thread->userType == 'agent') ? $thread->user->detail->agent->name : $thread->user->detail->customer->name,
						'thumbnail'    => $thread->user->smallThumbnail ? $thread->user->smallThumbnail : 'https://cdn.uvdesk.com/uvdesk/images/d94332c.png',
						'reply'		   => $thread->reply,
						'attachments'  => $attachments
						);
				}
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function download() {
		if (!$this->config->get('module_uvdesk_status')) {
			$this->response->redirect($this->url->link('account/account', '', true));
		}

		if (isset($this->request->get['attachment']) && $this->request->get['attachment']) {
			$attachment_id = $this->request->get['attachment'];
			$company_domain = $this->config->get('module_uvdesk_company_domain');
			$access_user_token = $this->config->get('module_uvdesk_access_user_token');
			$url = 'https://' . $company_domain . '.uvdesk.com/en/api/ticket/attachment/' . $attachment_id . '.json?access_user_token=' . $access_user_token;
			$this->response->redirect($url);
		}
	}

	public function addCollaborator() {
		$json = array();
		if (isset($this->request->post['email']) && $this->request->post['email']) {
			$this->load->model('uvdesk/uvdesk');
			$collaboratorInfo = $this->model_uvdesk_uvdesk->addCollaborator($this->request->post['id'], $this->request->post['email']);
			if (isset($collaboratorInfo->collaborator->id)) {
				$json['id'] = $collaboratorInfo->collaborator->id;
				if (isset($collaboratorInfo->collaborator->detail->agent)) {
					$json['name'] = $collaboratorInfo->collaborator->detail->agent->name;
				} elseif (isset($collaboratorInfo->collaborator->detail->customer)) {
					$json['name'] = $collaboratorInfo->collaborator->detail->customer->name;
				} else {
					$username = explode('@', $collaboratorInfo->collaborator->email);
					$json['name'] = $username[0];
				}
				if ($collaboratorInfo->collaborator->smallThumbnail) {
					$json['image'] = $collaboratorInfo->collaborator->smallThumbnail;
				} else {
					$json['image'] = 'https://cdn.uvdesk.com/uvdesk/images/d94332c.png';
				}
				$json['success'] = $collaboratorInfo->message;
			} else {
				if (isset($collaboratorInfo->message)) {
					$json['error'] = $collaboratorInfo->message;
				} elseif (isset($collaboratorInfo->description)) {
					$json['error'] = $collaboratorInfo->description;
				} elseif (isset($collaboratorInfo->error)) {
					$json['error'] = $collaboratorInfo->error;
				} else {
					$json['error'] = 'There seems to be some error while adding a collaborator';
				}
			}
		} else {
			$json['error'] = 'There seems to be some error while adding a collaborator';
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function removeCollaborator() {
		$json = array();
		if (isset($this->request->post['col_id']) && $this->request->post['col_id']) {
			$this->load->model('uvdesk/uvdesk');
			$remove = $this->model_uvdesk_uvdesk->removeCollaborator($this->request->post['id'], $this->request->post['col_id']);
			if (isset($remove->message)) {
				$json['success'] = $remove->message;
			} else {
				$json['error'] = 'There seems to be some error while removing collaborator';
			}
		} else {
			$json['error'] = 'There seems to be some error while removing collaborator';
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function addReply()	{
		$this->load->model('uvdesk/uvdesk');

		if (isset($this->request->post['reply']) && isset($this->request->post['id'])) {
			if ($this->request->post['reply']) {
				$ticket_id = $this->request->post['ticket_id'];
				$reply = $this->model_uvdesk_uvdesk->addThread($ticket_id, html_entity_decode($this->request->post['reply']));

				if (isset($reply->message)) {
					$this->session->data['success'] = $reply->message;
				} else {
					$this->session->data['warning'] = 'There is some issue while adding reply';
				}
			} else {
				$this->session->data['warning'] = 'You haven\'t provided any text in the reply box';
			}
			$this->response->redirect($this->url->link('uvdesk/uvdesk/view', 'id=' . $this->request->post['id'], true));
		}

		$this->response->redirect($this->url->link('uvdesk/uvdesk', '', true));
	}

	public function validate() {
		$this->load->model('uvdesk/uvdesk');

		if (!$this->customer->getId()) {
			if (!isset($this->request->post['name']) || (utf8_strlen(trim($this->request->post['name'])) < 1) || (utf8_strlen(trim($this->request->post['name'])) > 32)) {
				$this->error['name'] = $this->language->get('error_name');
			}

			if (!isset($this->request->post['email']) || (utf8_strlen($this->request->post['email']) > 96) || !filter_var($this->request->post['email'], FILTER_VALIDATE_EMAIL)) {
				$this->error['email'] = $this->language->get('error_email');
			}
		}

		if (!isset($this->request->post['type']) || !$this->request->post['type']) {
			$this->error['type'] = $this->language->get('error_type');
		}

		if (!isset($this->request->post['subject']) || (utf8_strlen(trim($this->request->post['subject'])) < 1) || (utf8_strlen(trim($this->request->post['subject'])) > 80)) {
			$this->error['subject'] = $this->language->get('error_subject');
		}

		if (!isset($this->request->post['message']) || utf8_strlen(trim($this->request->post['message'])) < 1) {
			$this->error['message'] = $this->language->get('error_message');
		}

		if ($this->error) {
			$this->error['warning'] = $this->language->get('error_warning');
		}

		return !$this->error;
	}

	public function uploadSummernoteImage() {

		$this->load->language('uvdesk/uvdesk');

		$dir = $this->customer->getFirstName() . $this->customer->getId();

		if (!file_exists(DIR_IMAGE . 'uvdesk/' . $dir)) {
			mkdir(DIR_IMAGE . 'uvdesk/' . $dir, 0777, true);
		}

		$json = array();

		if (!empty($this->request->files['file']['name']) && is_file($this->request->files['file']['tmp_name'])) {
			// Sanitize the filename
			$filename = basename(html_entity_decode($this->request->files['file']['name'], ENT_QUOTES, 'UTF-8'));

			// Validate the filename length
			if ((utf8_strlen($filename) < 3) || (utf8_strlen($filename) > 255)) {
				$json['error'] = $this->language->get('error_filename');
			}

			// Allowed file extension types
			$allowed = array(
				'jpg',
				'jpeg',
				'gif',
				'png'
			);

			if (!in_array(utf8_strtolower(utf8_substr(strrchr($filename, '.'), 1)), $allowed)) {
				$json['error'] = $this->language->get('error_filetype');
			}

			// Allowed file mime types
			$allowed = array(
				'image/jpeg',
				'image/pjpeg',
				'image/png',
				'image/x-png',
				'image/gif'
			);

			if (!in_array($this->request->files['file']['type'], $allowed)) {
				$json['error'] = $this->language->get('error_filetype');
			}

			// Check to see if any PHP files are trying to be uploaded
			$content = file_get_contents($this->request->files['file']['tmp_name']);

			if (preg_match('/\<\?php/i', $content)) {
				$json['error'] = $this->language->get('error_filetype');
			}

			// Return any upload error
			if ($this->request->files['file']['error'] != UPLOAD_ERR_OK) {
				$json['error'] = $this->language->get('error_upload_' . $this->request->files['file']['error']);
			}
		} else {
			$json['error'] = $this->language->get('error_upload');
		}

		if (!$json) {
			move_uploaded_file($this->request->files['file']['tmp_name'], DIR_IMAGE . 'uvdesk/' . $dir . '/' . $this->request->files['file']['name']);

			$json['image'] = HTTP_SERVER.'image/uvdesk/' . $dir . '/' . $this->request->files['file']['name'];

		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}
}
