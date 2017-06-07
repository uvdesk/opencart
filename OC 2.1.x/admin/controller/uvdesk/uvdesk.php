<?php
class ControllerUvdeskUvdesk extends Controller {
	private $error = array();

	public function index() {
		$data = $this->load->language('uvdesk/uvdesk');

		$this->document->setTitle($this->language->get('heading_title'));
		$this->document->addStyle('view/javascript/bootstrap-select/css/bootstrap-select.min.css');
		$this->document->addStyle('view/stylesheet/uvdesk/uvdesk.css');
		$this->document->addScript('view/javascript/bootstrap-select/js/bootstrap-select.min.js');

		$this->load->model('uvdesk/uvdesk');

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 'name';
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'ASC';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}

		if (isset($this->request->get['tab'])) {
			$tab = $this->request->get['tab'];
		} else {
			$tab = 1;
		}

		if (isset($this->request->get['custom_label'])) {
			$custom_label = $this->request->get['custom_label'];
		} else {
			$custom_label = '';
		}

		if (isset($this->request->get['label'])) {
			$label = $this->request->get['label'];
		} else {
			if (!$custom_label) {
				$label = 'all';
			} else {
				$label = '';
			}
		}

		if (isset($this->request->get['search'])) {
			$search = $this->request->get['search'];
		} else {
			$search = '';
		}

		if (isset($this->request->get['customer'])) {
			$customer = $this->request->get['customer'];
		} else {
			$customer = '';
		}

		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		if (isset($this->request->get['label'])) {
			$url .= '&label=' . $this->request->get['label'];
		}

		if (isset($this->request->get['custom_label'])) {
			$url .= '&custom_label=' . $this->request->get['custom_label'];
		}

		if (isset($this->request->get['search'])) {
			$url .= '&search=' . $this->request->get['search'];
		}

		if (isset($this->request->get['customer'])) {
			$url .= '&customer=' . $this->request->get['customer'];
		}

		$data['tab_active'] = $tab;
		$data['tab_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url . '&tab=', true);

		if (isset($this->request->get['tab'])) {
			$url .= '&tab=' . $this->request->get['tab'];
		}

		$data['url'] = $url;

		$data['label_active'] = $label;
		$data['label_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&label=', true);
		$data['custom_label_active'] = $custom_label;
		$data['custom_label_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&custom_label=', true);
		$data['search'] = $search;
		$data['search_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url . '&search=', true);

		$data['view'] = $this->url->link('uvdesk/uvdesk/view', 'token=' . $this->session->data['token'] . $url, true);
		$data['delete'] = $this->url->link('uvdesk/uvdesk/delete', 'token=' . $this->session->data['token'] . $url, true);

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url, true)
		);

		$data['tickets'] = array();

		$filter_data = array(
			'sort'  => $sort,
			'order' => $order,
			'page'  => $page,
			'tab'	=> $tab,
			'label' => $label,
			'custom_label' => $custom_label,
			'search' => $search,
			'customer' => $customer
		);

		$tickets = $this->model_uvdesk_uvdesk->getTickets($filter_data);

		if (isset($tickets->error) || !$tickets) {
			if (isset($tickets->error_description)) {
				$data['error'] = $tickets->error_description;
			} elseif (isset($tickets->description)) {
				$data['error'] = $tickets->description;
			} else {
				$data['error'] = $this->language->get('error_uvdesk');
			}

			$data['header'] = $this->load->controller('common/header');
			$data['column_left'] = $this->load->controller('common/column_left');
			$data['footer'] = $this->load->controller('common/footer');

			$this->response->setOutput($this->load->view('uvdesk/error_page.tpl', $data));
			return;
		}

		$ticket_total = $tickets->pagination->totalCount;

		$data['user_details'] = $tickets->userDetails;

		$items_on_page = $tickets->pagination->numItemsPerPage;

		$data['tab'] = $tickets->tabs;

		$data['predefined_labels'] = $tickets->labels->predefind;
		$data['custom_labels'] = $tickets->labels->custom;

		$groups = array();

		if (isset($tickets->group) && $tickets->group) {
			foreach ($tickets->group as $group) {
				$groups[] = array(
					'id'   => $group->id,
					'name' => $group->name
					);
			}
		}

		$data['groups'] = json_encode($groups);

		$teams = array();

		if (isset($tickets->team) && $tickets->team) {
			foreach ($tickets->team as $team) {
				$teams[] = array(
					'id'   => $team->id,
					'name' => $team->name
					);
			}
		}

		$data['teams'] = json_encode($teams);

		$priorities = array();

		if (isset($tickets->priority) && $tickets->priority) {
			foreach ($tickets->priority as $priority) {
				$priorities[] = array(
					'id'   => $priority->id,
					'name' => $priority->name
					);
			}
		}

		$data['priorities'] = json_encode($priorities);

		$types = array();

		if (isset($tickets->type) && $tickets->type) {
			foreach ($tickets->type as $type) {
				if ($type->isActive) {
					$types[] = array(
						'id'   => $type->id,
						'name' => $type->name
						);
				}
			}
		}

		$data['types'] = json_encode($types);

		$mailboxes = array();

		if (isset($tickets->mailbox) && $tickets->mailbox) {
			foreach ($tickets->mailbox as $mailbox) {
				if ($mailbox->isActive) {
					$mailboxes[] = array(
						'id'   => $mailbox->id,
						'name' => $mailbox->name
						);
				}
			}
		}

		$data['mailboxes'] = json_encode($mailboxes);

		$results = $tickets->tickets;

		foreach ($results as $result) {
			$data['tickets'][] = array(
				'ticket_id' => $result->incrementId,
				'priority'  => $result->priority ? array(
					'name'  => $result->priority->name,
					'color' => $result->priority->color
					) : array(
					'name'  => '',
					'color' => ''
					),
				'cname'      => $result->customer->name,
				'subject'    => (strlen($result->subject) < 50) ? $result->subject : utf8_substr($result->subject, 0, 50) . '...',
				'date_added' => $result->formatedCreatedAt,
				'threads'    => $result->totalThreads,
				'attachments' => $result->hasAttachments,
				'agent'      => $result->agent ? $result->agent->name : '',
				'view'       => $this->url->link('uvdesk/uvdesk/view', 'id=' . $result->incrementId . '&token=' . $this->session->data['token'], true)

			);
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} elseif (isset($this->session->data['warning'])) {
			$data['error_warning'] = $this->session->data['warning'];

			unset($this->session->data['warning']);
		} else {
			$data['error_warning'] = '';
		}

		if (isset($this->session->data['success'])) {
			$data['success'] = $this->session->data['success'];

			unset($this->session->data['success']);
		} else {
			$data['success'] = '';
		}

		if (isset($this->request->post['selected'])) {
			$data['selected'] = (array)$this->request->post['selected'];
		} else {
			$data['selected'] = array();
		}

		if (isset($this->request->get['filter_name'])) {
			$data['filter_name'] = $this->request->get['filter_name'];
		} else {
			$data['filter_name'] = '';
		}

		$url = '';

		if ($order == 'ASC') {
			$url .= '&order=DESC';
		} else {
			$url .= '&order=ASC';
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		$data['sort_name'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&sort=name' . $url, true);
		$data['sort_status'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&sort=status' . $url, true);

		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['tab'])) {
			$url .= '&tab=' . $this->request->get['tab'];
		}

		if (isset($this->request->get['label'])) {
			$url .= '&label=' . $this->request->get['label'];
		}

		if (isset($this->request->get['custom_label'])) {
			$url .= '&custom_label=' . $this->request->get['custom_label'];
		}

		if (isset($this->request->get['search'])) {
			$url .= '&search=' . $this->request->get['search'];
		}

		$pagination = new Pagination();
		$pagination->total = $ticket_total;
		$pagination->page = $page;
		$pagination->limit = $items_on_page;
		$pagination->url = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url . '&page={page}', true);

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($ticket_total) ? (($page - 1) * $items_on_page) + 1 : 0, ((($page - 1) * $items_on_page) > ($ticket_total - $items_on_page)) ? $ticket_total : ((($page - 1) * $items_on_page) + $items_on_page), $ticket_total, ceil($ticket_total / $items_on_page));

		$data['sort'] = $sort;
		$data['order'] = $order;
		$data['token'] = $this->session->data['token'];

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('uvdesk/uvdesk.tpl', $data));
	}

	public function assignAgent() {
		$json = array();
		$this->load->model('uvdesk/uvdesk');

		if (isset($this->request->post['agent_id']) && $this->request->post['agent_id'] && isset($this->request->post['agent_id']) && $this->request->post['agent_id']) {
			$ticket_id = $this->request->post['ticket_id'];
			$agent_id = $this->request->post['agent_id'];
			$members = $this->model_uvdesk_uvdesk->assignAgent($ticket_id, $agent_id);
			$json['success'] = $members->message;
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function view() {
		$data = $this->language->load('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');
		$this->document->addStyle('view/stylesheet/uvdesk/ticket_view.css');

		if (isset($this->request->get['id']) && $this->request->get['id']) {
			$data['id'] = $ticket_id = $this->request->get['id'];
			$data['ticket'] = $ticket = $this->model_uvdesk_uvdesk->getTicket($ticket_id);
			if (isset($ticket->error) || !$ticket) {
				if (isset($ticket->error_description)) {
					$data['error'] = $ticket->error_description;
				} elseif (isset($ticket->description)) {
					$data['error'] = $ticket->description;
				} else {
					$data['error'] = $this->language->get('error_uvdesk');
				}

				$data['header'] = $this->load->controller('common/header');
				$data['column_left'] = $this->load->controller('common/column_left');
				$data['footer'] = $this->load->controller('common/footer');

				$this->response->setOutput($this->load->view('uvdesk/error_page.tpl', $data));
				return;
			}

			$data['thread_id'] = $ticket->ticket->id;

			$this->document->setTitle($ticket->ticket->subject);
			$data['predefined_labels'] = $ticket->labels->predefind;
			$data['custom_labels'] = $ticket->labels->custom;
		}

		$url = '';

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url, true)
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

		if (isset($this->request->get['label'])) {
			$label = $this->request->get['label'];
		} else {
			$label = '';
		}

		if (isset($this->request->get['custom_label'])) {
			$custom_label = $this->request->get['custom_label'];
		} else {
			$custom_label = '';
		}

		$data['label_active'] = $label;
		$data['label_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&label=', true);
		$data['attachment_url'] = $this->url->link('uvdesk/uvdesk/download', 'token=' . $this->session->data['token'] . '&attachment=', true);
		$data['custom_label_active'] = $custom_label;
		$data['custom_label_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . '&custom_label=', true);
		$data['token'] = $this->session->data['token'];

		$data['add_reply'] = $this->url->link('uvdesk/uvdesk/addReply', 'token=' . $this->session->data['token'], true);
		$data['size'] = $this->config->get('config_file_max_size');
		// $extensions = $this->config->get('config_file_ext_allowed');
		$extension_allowed = preg_replace('~\r?\n~', "\n", $this->config->get('config_file_ext_allowed'));
		$data['extensions'] = explode("\n", $extension_allowed);

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('uvdesk/ticket_view.tpl', $data));
	}

	public function addReply()	{
		$this->load->model('uvdesk/uvdesk');

		if (isset($this->request->post['reply']) && $this->request->post['reply']) {
			$ticket_id = $this->request->post['ticket_id'];
			$reply = $this->model_uvdesk_uvdesk->addThread($ticket_id, html_entity_decode($this->request->post['reply']));

			if (isset($reply->message)) {
				$this->session->data['success'] = $reply->message;
			} else {
				$this->session->data['success'] = 'Reply Added';
			}
			$this->response->redirect($this->url->link('uvdesk/uvdesk/view', 'id=' . $this->request->post['id'] . '&token=' . $this->session->data['token'], true));
		}

		$this->session->data['warning'] = 'You haven\'t added a reply';

		$this->response->redirect($this->url->link('uvdesk/uvdesk/view', 'id=' . $this->request->post['id'] . '&token=' . $this->session->data['token'], true));
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
						'user_type'    => (($thread->userType == 'agent') ? 'Agent' : 'Customer'),
						'name'         => ($thread->userType == 'agent') ? $thread->user->detail->agent->name : $thread->user->detail->customer->name,
						'thumbnail'    => $thread->user->smallThumbnail ? $thread->user->smallThumbnail : 'https://cdn.uvdesk.com/uvdesk/images/d94332c.png',
						'reply'		   => html_entity_decode($thread->reply),
						'attachments'  => $attachments
						);
				}
			}
		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function getFilters() {
		$json = array();

		if (isset($this->request->get['search']) && isset($this->request->post['type'])) {
			$this->load->model('uvdesk/uvdesk');

			$data = array();

			$name = $this->request->get['search'];

			$type = $this->request->post['type'];

			switch ($type) {
				case 'filter-customer':
					$customers = $this->model_uvdesk_uvdesk->getCustomers($name);

					if (isset($customers->customers)) {
						foreach ($customers->customers as $customer) {
							$json['results'][] = array(
									'title' => $customer->name,
									'id'  => $customer->id
								);
						}
					}
					break;
				case 'filter-assigned':
					$members = $this->model_uvdesk_uvdesk->getMembers($name);

					if (isset($members)) {
						foreach ($members as $member) {
							$json['results'][] = array(
									'title' => $member->name,
									'id'  => $member->id
								);
						}
					}
					break;
				case 'filter-tag':
					$tags = $this->model_uvdesk_uvdesk->getTags($name);

					if (isset($tags->tags)) {
						foreach ($tags->tags as $tag) {
							$json['results'][] = array(
									'title' => $tag->name,
									'id'  => $tag->id
								);
						}
					}
					break;
			    default:
			        echo "error";
			}

		}

		$this->response->addHeader('Content-Type: application/json');
		$this->response->setOutput(json_encode($json));
	}

	public function filteredTickets() {
		$data = $this->load->language('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');

		$isAjax = isset($_SERVER['HTTP_X_REQUESTED_WITH']) AND strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest';

		if (!$isAjax) {
			$this->response->redirect($this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'], true));
		}

		if (isset($this->request->get['sort'])) {
			$sort = $this->request->get['sort'];
		} else {
			$sort = 't.updatedAt';
		}

		if (isset($this->request->get['order'])) {
			$order = $this->request->get['order'];
		} else {
			$order = 'DESC';
		}

		if (isset($this->request->get['page'])) {
			$page = $this->request->get['page'];
		} else {
			$page = 1;
		}

		if (isset($this->request->get['tab'])) {
			$tab = $this->request->get['tab'];
		} else {
			$tab = 1;
		}

		if (isset($this->request->get['custom_label'])) {
			$custom_label = $this->request->get['custom_label'];
		} else {
			$custom_label = '';
		}

		if (isset($this->request->get['label'])) {
			$label = $this->request->get['label'];
		} else {
			if (!$custom_label) {
				$label = 'all';
			} else {
				$label = '';
			}
		}

		if (isset($this->request->get['search'])) {
			$search = $this->request->get['search'];
		} else {
			$search = '';
		}

		if (isset($this->request->get['agent'])) {
			$agent = $this->request->get['agent'];
		} else {
			$agent = '';
		}

		if (isset($this->request->get['customer'])) {
			$customer = $this->request->get['customer'];
		} else {
			$customer = '';
		}

		if (isset($this->request->get['group'])) {
			$group = $this->request->get['group'];
		} else {
			$group = '';
		}

		if (isset($this->request->get['team'])) {
			$team = $this->request->get['team'];
		} else {
			$team = '';
		}

		if (isset($this->request->get['priority'])) {
			$priority = $this->request->get['priority'];
		} else {
			$priority = '';
		}

		if (isset($this->request->get['type'])) {
			$type = $this->request->get['type'];
		} else {
			$type = '';
		}

		if (isset($this->request->get['tag'])) {
			$tag = $this->request->get['tag'];
		} else {
			$tag = '';
		}

		if (isset($this->request->get['mailbox'])) {
			$mailbox = $this->request->get['mailbox'];
		} else {
			$mailbox = '';
		}

		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['page'])) {
			$url .= '&page=' . $this->request->get['page'];
		}

		if (isset($this->request->get['label'])) {
			$url .= '&label=' . $this->request->get['label'];
		}

		if (isset($this->request->get['custom_label'])) {
			$url .= '&custom_label=' . $this->request->get['custom_label'];
		}

		if (isset($this->request->get['search'])) {
			$url .= '&search=' . $this->request->get['search'];
		}

		if (isset($this->request->get['customer'])) {
			$url .= '&customer=' . $this->request->get['customer'];
		}

		$data['tickets'] = array();

		$filter_data = array(
			'sort'     => $sort,
			'order'    => $order,
			'page'     => $page,
			'tab'	   => $tab,
			'label'    => $label,
			'custom_label' => $custom_label,
			'search'   => $search,
			'priority' => $priority,
			'group'    => $group,
			'team'     => $team,
			'type'     => $type,
			'tag'      => $tag,
			'mailbox'  => $mailbox,
			'agent'    => $agent,
			'customer' => $customer
		);

		$tickets = $this->model_uvdesk_uvdesk->getTickets($filter_data);

		$ticket_total = $tickets->pagination->totalCount;

		$data['user_details'] = $tickets->userDetails;

		$items_on_page = $tickets->pagination->numItemsPerPage;

		$data['tab'] = $tickets->tabs;

		$data['predefined_labels'] = $tickets->labels->predefind;
		$data['custom_labels'] = $tickets->labels->custom;

		$results = $tickets->tickets;

		foreach ($results as $result) {
			$data['tickets'][] = array(
				'id'        => $result->id,
				'ticket_id' => $result->incrementId,
				'priority'  => $result->priority ? array(
					'name'  => $result->priority->name,
					'color' => $result->priority->color
					) : array(
					'name'  => '',
					'color' => ''
					),
				'cname'      => $result->customer->name,
				'subject'    => (strlen($result->subject) < 50) ? $result->subject : utf8_substr($result->subject, 0, 50) . '...',
				'date_added' => $result->formatedCreatedAt,
				'threads'    => $result->totalThreads,
				'attachments' => $result->hasAttachments,
				'agent'      => $result->agent ? $result->agent->name : '',
				'agent_id'   => $result->agent ? $result->agent->id : 0,
				'view'       => $this->url->link('uvdesk/uvdesk/view', 'id=' . $result->incrementId . '&token=' . $this->session->data['token'], true)

			);
		}

		$url = '';

		if (isset($this->request->get['sort'])) {
			$url .= '&sort=' . $this->request->get['sort'];
		}

		if (isset($this->request->get['order'])) {
			$url .= '&order=' . $this->request->get['order'];
		}

		if (isset($this->request->get['tab'])) {
			$url .= '&tab=' . $this->request->get['tab'];
		}

		if (isset($this->request->get['label'])) {
			$url .= '&label=' . $this->request->get['label'];
		}

		if (isset($this->request->get['custom_label'])) {
			$url .= '&custom_label=' . $this->request->get['custom_label'];
		}

		if (isset($this->request->get['search'])) {
			$url .= '&search=' . $this->request->get['search'];
		}

		$data['tab_active'] = $tab;
		$data['tab_url'] = $this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'] . $url . '&tab=', true);
		$data['delete'] = $this->url->link('uvdesk/uvdesk/delete', 'token=' . $this->session->data['token'], true);

		$pagination = new Pagination();
		$pagination->total = $ticket_total;
		$pagination->page = $page;
		$pagination->limit = $items_on_page;
		$pagination->url = $this->url->link('uvdesk/uvdesk/filteredTickets', 'token=' . $this->session->data['token'] . $url . '&page={page}', true);

		$data['pagination'] = $pagination->render();

		$data['results'] = sprintf($this->language->get('text_pagination'), ($ticket_total) ? (($page - 1) * $items_on_page) + 1 : 0, ((($page - 1) * $items_on_page) > ($ticket_total - $items_on_page)) ? $ticket_total : ((($page - 1) * $items_on_page) + $items_on_page), $ticket_total, ceil($ticket_total / $items_on_page));

		return $this->response->setOutput($this->load->view('uvdesk/list_view.tpl', $data));
	}

	public function download() {
		if (isset($this->request->get['attachment']) && $this->request->get['attachment']) {
			$attachment_id = $this->request->get['attachment'];
			$company_domain = $this->config->get('uvdesk_company_domain');
			$access_token = $this->config->get('uvdesk_access_token');
			$url = 'https://' . $company_domain . '.uvdesk.com/en/api/ticket/attachment/' . $attachment_id . '.json?access_token=' . $access_token;
			$this->response->redirect($url);
		}
	}

	public function delete() {
		if (isset($this->request->post['selected']) && $this->request->post['selected'] && $this->validateDelete()) {
			$this->load->model('uvdesk/uvdesk');
			$ids = $this->request->post['selected'];

			$delete = $this->model_uvdesk_uvdesk->deleteTickets($ids);

			if (isset($delete->deletedTickets) && $delete->deletedTickets) {
				$this->session->data['success'] = $delete->message;
			} elseif (isset($delete->warning) && $delete->warning) {
				$this->session->data['warning'] = $delete->warning;
			}
		} else {
			$this->session->data['warning'] = 'Ticket(s) not found';
		}
		$this->response->redirect($this->url->link('uvdesk/uvdesk', 'token=' . $this->session->data['token'], true));
	}

	protected function validateDelete() {
		if (!$this->user->hasPermission('modify', 'uvdesk/uvdesk')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}
}
