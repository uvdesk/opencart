<?php
class ControllerExtensionModuleUvdesk extends Controller {
	private $error = array();

	public function index() {
		$data = $this->load->language('extension/module/uvdesk');

		$this->document->setTitle($this->language->get('heading_title'));

		$this->load->model('setting/setting');

		if (($this->request->server['REQUEST_METHOD'] == 'POST') && $this->validate()) {
			$this->model_setting_setting->editSetting('module_uvdesk', $this->request->post);

			$this->session->data['success'] = $this->language->get('text_success');

			$this->response->redirect($this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true));
		}

		if (isset($this->error['warning'])) {
			$data['error_warning'] = $this->error['warning'];
		} else {
			$data['error_warning'] = '';
		}

		$data['breadcrumbs'] = array();

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_home'),
			'href' => $this->url->link('common/dashboard', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('text_module'),
			'href' => $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true)
		);

		$data['breadcrumbs'][] = array(
			'text' => $this->language->get('heading_title'),
			'href' => $this->url->link('extension/module/uvdesk', 'user_token=' . $this->session->data['user_token'], true)
		);

		$data['action'] = $this->url->link('extension/module/uvdesk', 'user_token=' . $this->session->data['user_token'], true);

		$data['cancel'] = $this->url->link('marketplace/extension', 'user_token=' . $this->session->data['user_token'] . '&type=module', true);

		if (isset($this->request->post['module_uvdesk_status'])) {
			$data['module_uvdesk_status'] = $this->request->post['module_uvdesk_status'];
		} else {
			$data['module_uvdesk_status'] = $this->config->get('module_uvdesk_status');
		}

		if (isset($this->request->post['module_uvdesk_access_token'])) {
			$data['module_uvdesk_access_token'] = $this->request->post['module_uvdesk_access_token'];
		} else {
			$data['module_uvdesk_access_token'] = $this->config->get('module_uvdesk_access_token');
		}

		if (isset($this->request->post['module_uvdesk_company_domain'])) {
			$data['module_uvdesk_company_domain'] = $this->request->post['module_uvdesk_company_domain'];
		} else {
			$data['module_uvdesk_company_domain'] = $this->config->get('module_uvdesk_company_domain');
		}

		$data['header'] = $this->load->controller('common/header');
		$data['column_left'] = $this->load->controller('common/column_left');
		$data['footer'] = $this->load->controller('common/footer');

		$this->response->setOutput($this->load->view('extension/module/uvdesk', $data));
	}

	protected function validate() {
		if (!$this->user->hasPermission('modify', 'extension/module/uvdesk')) {
			$this->error['warning'] = $this->language->get('error_permission');
		}

		return !$this->error;
	}
}
