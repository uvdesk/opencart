<?php
class ControllerModuleUvdesk extends Controller {
	private $error = array();

	public function index() {
		$data = $this->load->language('module/uvdesk');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('uvdesk', $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('extension/module', 'token=' . $this->session->data['token'], true));
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'token=' . $this->session->data['token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_module'),
			'href' => $this->url->link('extension/module', 'token=' . $this->session->data['token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('module/uvdesk', 'token=' . $this->session->data['token'], true)
		);

		$data['action'] = $this->url->link('module/uvdesk', 'token=' . $this->session->data['token'], true);

		$data['cancel'] = $this->url->link('extension/module', 'token=' . $this->session->data['token'], true);

		if (isset($this->request->post['uvdesk_status'])) {
			$data['uvdesk_status'] = $this->request->post['uvdesk_status'];
		} else {
			$data['uvdesk_status'] = $this->config->get('uvdesk_status');
		}

		if (isset($this->request->post['uvdesk_access_token'])) {
			$data['uvdesk_access_token'] = $this->request->post['uvdesk_access_token'];
		} else {
			$data['uvdesk_access_token'] = $this->config->get('uvdesk_access_token');
		}

		if (isset($this->request->post['uvdesk_company_domain'])) {
			$data['uvdesk_company_domain'] = $this->request->post['uvdesk_company_domain'];
		} else {
			$data['uvdesk_company_domain'] = $this->config->get('uvdesk_company_domain');
		}

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('module/uvdesk.tpl', $data));
	}

	protected function validate() {
		if (!$this->user->hasPermission('modify', 'module/uvdesk')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}
}