<div class="panel-heading">
  <div class="btn-group width-100">
    <a tab-id="1" class="btn btn-default width-16 <?php if($tab_active == 1) echo 'onfocus'; ?>"><i class="fa fa-inbox"></i> <span class="hidden-xs"><?php echo $tab_open; ?></span><br><span class="label label-info"><?php echo $tab->{1}; ?></span></a>
    <a tab-id="2" class="btn btn-default width-16 <?php if($tab_active == 2) echo 'onfocus'; ?>"><i class="fa fa-exclamation-triangle"></i> <span class="hidden-xs"><?php echo $tab_pending; ?></span><br><span class="label label-info"><?php echo $tab->{2}; ?></span></a>
    <a tab-id="6" class="btn btn-default width-16 <?php if($tab_active == 6) echo 'onfocus'; ?>"><i class="fa fa-lightbulb-o"></i> <span class="hidden-xs"><?php echo $tab_answered; ?></span><br><span class="label label-info"><?php echo $tab->{6}; ?></span></a>
    <a tab-id="3" class="btn btn-default width-16 <?php if($tab_active == 3) echo 'onfocus'; ?>"><i class="fa fa-check-circle"></i> <span class="hidden-xs"><?php echo $tab_resolved; ?></span><br><span class="label label-info"><?php echo $tab->{3}; ?></span></a>
    <a tab-id="4" class="btn btn-default width-16 <?php if($tab_active == 4) echo 'onfocus'; ?>"><i class="fa fa-minus-circle"></i> <span class="hidden-xs"><?php echo $tab_closed; ?></span><br><span class="label label-info"><?php echo $tab->{4}; ?></span></a>
    <a tab-id="5" class="btn btn-default width-16 <?php if($tab_active == 5) echo 'onfocus'; ?>"><i class="fa fa-ban"></i> <span class="hidden-xs"><?php echo $tab_spam; ?></span><br><span class="label label-info"><?php echo $tab->{5}; ?></span></a>
  </div>
</div>
<div class="panel-body">
  <form action="<?php echo $delete; ?>" method="post" enctype="multipart/form-data" id="form-ticket">
    <div class="table-responsive">
      <table class="table table-bordered table-hover">
        <thead>
          <tr>
            <td style="width: 1px;" class="text-center"><input type="checkbox" onclick="$('input[name*=\'selected\']').prop('checked', this.checked);" /></td>
            <td class="text-center"><?php echo $column_priority; ?></td>
            <td class="text-center"><?php echo $column_ticket_no; ?></td>
            <td class="text-center"><?php echo $column_cname; ?></td>
            <td class="text-center"><?php echo $column_subject; ?></td>
            <td class="text-center"><?php echo $column_date_added; ?></td>
            <td class="text-center"><?php echo $column_replies; ?></td>
            <td class="text-center" style="width: 20%;"><?php echo $column_agent; ?></td>
            <td class="text-center"><?php echo $column_action; ?></td>
          </tr>
        </thead>
        <tbody>
          <?php if ($tickets) { ?>
          <?php foreach ($tickets as $ticket) { ?>
          <tr>
            <td class="text-center">
              <input type="checkbox" name="selected[]" value="<?php echo $ticket['id']; ?>" />
            </td>
            <td class="text-center" style="color: <?php echo $ticket['priority']['color']; ?>; font-weight: bold;"><?php echo $ticket['priority']['name']; ?></td>
            <td class="text-center">#<?php echo $ticket['ticket_id']; ?></td>
            <td class="text-center"><?php echo $ticket['cname']; ?></td>
            <td class="text-center"><i class="<?php echo $ticket['attachments'] ? "fa fa-paperclip" : ''; ?>"></i> <?php echo $ticket['subject']; ?></td>
            <td class="text-center"><?php echo $ticket['date_added']; ?></td>
            <td class="text-center"><span class="label label-info"><?php echo $ticket['threads']; ?></span></td>
            <td class="text-left" ticket-id="<?php echo $ticket['id']; ?>" agent-id="<?php echo $ticket['agent_id']; ?>">
              <?php if($ticket['agent']) { ?>
              <span class="badge"><i class="fa fa-pencil"></i></span> 
              <span class="agentName"><?php echo $ticket['agent']; ?></span>
              <?php } else { ?>
              <span data-toggle="tooltip" title="Add agent" class="btn btn-primary addAgent"><i class="fa fa-plus-circle"></i></span>
              <?php } ?>
              <select class="selectpicker" data-show-subtext="true" data-live-search="true"></select>
            </td>
            <td class="text-center"><a href="<?php echo $ticket['view']; ?>" class="btn btn-info">View</a></td>
          </tr>
          <?php } ?>
          <?php } else { ?>
          <tr>
            <td class="text-center" colspan="8"><?php echo $text_no_results; ?></td>
          </tr>
          <?php } ?>
        </tbody>
      </table>
    </div>
  </form>
  <div class="row">
    <div class="col-sm-6 text-left"><?php echo $pagination; ?></div>
    <div class="col-sm-6 text-right"><?php echo $results; ?></div>
  </div>
</div>