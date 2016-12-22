<?php echo $header; ?>
<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
  <?php } ?>
  <?php if ($error_warning) { ?>
  <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?></div>
  <?php } ?>
  <div class="row"><?php echo $column_left; ?>
    <?php if ($column_left && $column_right) { ?>
    <?php $class = 'col-sm-6'; ?>
    <?php } elseif ($column_left || $column_right) { ?>
    <?php $class = 'col-sm-9'; ?>
    <?php } else { ?>
    <?php $class = 'col-sm-12'; ?>
    <?php } ?>
    <div id="content" class="<?php echo $class; ?>"><?php echo $content_top; ?>
      <div class="col-sm-8">
        <div class="panel panel-default">
          <h2><?php echo $text_create; ?></h2>
          <div class="panel-body">
            <form action="<?php echo $action; ?>" method="post" enctype="multipart/form-data" class="form-horizontal">
              <?php if (!$isCustomer) { ?>
              <div class="form-group required">
                <label for="input-name" class="col-sm-12 control-label"><?php echo $entry_name; ?></label>
                <div class="col-sm-12">
                  <input type="text" name="name" class="form-control" placeholder="<?php echo $entry_enter . $entry_name; ?>">
                  <?php if ($error_name) { ?>
                  <div class="text-danger"><?php echo $error_name; ?></div>
                  <?php } ?>
                </div>
              </div>
              <div class="form-group required">
                <label for="input-email" class="col-sm-12 control-label"><?php echo $entry_email; ?></label>
                <div class="col-sm-12">
                  <input type="text" name="email" class="form-control" placeholder="<?php echo $entry_enter . $entry_email; ?>">
                  <?php if ($error_email) { ?>
                  <div class="text-danger"><?php echo $error_email; ?></div>
                  <?php } ?>
                </div>
              </div>
              <?php } ?>
              <div class="form-group required">
                <label for="input-type" class="col-sm-12 control-label"><?php echo $entry_type; ?></label>
                <div class="col-sm-12">
                  <select name="type" class="form-control">
                    <?php if ($types) { ?>
                    <?php foreach ($types as $typ) { ?>
                    <?php if ($type == $typ['value']) { ?>
                    <option value="<?php echo $typ['value']; ?>" selected><?php echo $typ['name']; ?></option>
                    <?php } else { ?>
                    <option value="<?php echo $typ['value']; ?>"><?php echo $typ['name']; ?></option>
                    <?php } ?>
                    <?php } ?>
                    <?php } ?>
                  </select>
                  <?php if ($error_type) { ?>
                  <div class="text-danger"><?php echo $error_type; ?></div>
                  <?php } ?>
                </div>
              </div>
              <div class="form-group required">
                <label for="input-subject" class="col-sm-12 control-label"><?php echo $entry_subject; ?></label>
                <div class="col-sm-12">
                  <input type="text" name="subject" class="form-control" placeholder="<?php echo $entry_enter . $entry_subject; ?>" value="<?php echo $subject; ?>">
                  <?php if ($error_subject) { ?>
                  <div class="text-danger"><?php echo $error_subject; ?></div>
                  <?php } ?>
                </div>
              </div>
              <div class="form-group required">
                <label for="input-message" class="col-sm-12 control-label"><?php echo $entry_message; ?></label>
                <div class="col-sm-12">
                  <textarea name="message" class="form-control" placeholder="<?php echo $help_message; ?>"><?php echo $message; ?></textarea>
                  <?php if ($error_message) { ?>
                  <div class="text-danger"><?php echo $error_message; ?></div>
                  <?php } ?>
                </div>
              </div>
              <input type="submit" class="btn btn-primary" value="<?php echo $button_create; ?>">
          </div>
        </div>
      </div>
      <div class="col-sm-4">
        <div class="panel panel-default">
          <div class="panel-body">
            <p>
              <span class="badge"><i class="fa fa-info"></i></span>
              <label class="information-block-title"><span class="Apple-converted-space">&nbsp;</span>Help and Information</label>
              <br>
            </p>
            <div class="information-item">
              <label>Ticket</label>
              <p>A ticket is the support request submitted by the customers to inquire about their problems.</p>
            </div>
            <div class="information-item">
              <label>Ticket creation</label>
              <p>The moment when the users enter their basic details, they get registered with UVdesk services and confirmation mail regarding the account activation is sent to their ID’s. They have to click on the link provided for setting the password.</p>
            </div>
          </div>
        </div>
      </div>
      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<link href="catalog/view/theme/default/stylesheet/uvdesk/form.css" rel="stylesheet" type="text/css" />
<?php echo $footer; ?> 