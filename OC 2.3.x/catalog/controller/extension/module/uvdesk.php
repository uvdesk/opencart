<?php
class ControllerExtensionModuleUvdesk extends Controller {
	public function index() {
		if (!$this->customer->getId()) {
			return;
		}

		$data = $this->load->language('uvdesk/uvdesk');
		$this->load->model('uvdesk/uvdesk');

		if (isset($this->session->data['uvdesk_customer_id'])) {
			$data['isTicketCustomer'] = true;
		} else {
			$customer = $this->model_uvdesk_uvdesk->getCustomer();

			if (isset($customer->error)) {
				return;
			}

			if (isset($customer->customers[0])) {
				$data['isTicketCustomer'] = true;

				$this->session->data['uvdesk_customer_id'] = $customer->customers[0]->id;
			} else {
				$data['isTicketCustomer'] = false;
			}
		}

		$data['ticket_url'] = $this->url->link('uvdesk/uvdesk/view', '', true);
		$data['create_ticket'] = $this->url->link('uvdesk/uvdesk/create', '', true);
		$data['view_tickets'] = $this->url->link('uvdesk/uvdesk', '', true);

		return $this->load->view('extension/module/uvdesk', $data);
	}
}