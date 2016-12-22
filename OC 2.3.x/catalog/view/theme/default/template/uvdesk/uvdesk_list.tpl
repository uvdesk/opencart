<?php echo $header; ?>
<link href="catalog/view/theme/default/stylesheet/uvdesk/list.css" rel="stylesheet" type="text/css" />
<div class="container">
  <ul class="breadcrumb">
    <?php foreach ($breadcrumbs as $breadcrumb) { ?>
    <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
    <?php } ?>
  </ul>
  <?php if ($success) { ?>
  <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
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
      <h2><?php echo $heading_tickets; ?></h2>
      <div class="panel panel-default">
        <div class="panel-heading">
          <?php if ($isTicketCustomer) { ?>
          <h3 class="panel-title pull-left"><i class="fa fa-list"></i> <?php echo $text_list; ?></h3>
          <?php } ?>
          <a href="<?php echo $create_ticket; ?>" class="btn btn-primary pull-right"><?php echo $button_create; ?></a>
        </div>
      <?php if (!$isTicketCustomer) { ?>
      </div>
      <?php return; } ?>
        <div class="panel-body">
          <div class="row">
            <div class="col-sm-3">
              <div class="dropdown">
                <button class="btn label label-info dropdown-toggle width-100" data-toggle="dropdown"><?php echo $text_sort_by; ?> <i class="caret"></i></button>
                <ul class="dropdown-menu dropdown-menu-left uvsort">
                  <li><a sort="t.id" class="uvfocus"><?php echo $sort_ticket_id; ?> <i class="fa fa-chevron-down sortChevron"></i></a></li>
                  <li><a sort="agentName"><?php echo $sort_agent_name; ?></a></li>
                </ul>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="dropdown">
                <button class="btn label label-info dropdown-toggle width-100" data-toggle="dropdown"><?php echo $text_filter_by; ?> <i class="caret"></i></button>
                <ul class="dropdown-menu dropdown-menu-left uvstatus">
                  <li><a status="0" class="uvfocus"><?php echo $text_filter_by; ?></a></li>
                  <li><a status="1"><?php echo $filter_open; ?></a></li>
                  <li><a status="2"><?php echo $filter_pending; ?></a></li>
                  <li><a status="6"><?php echo $filter_answered; ?></a></li>
                  <li><a status="3"><?php echo $filter_resolved; ?></a></li>
                  <li><a status="4"><?php echo $filter_closed; ?></a></li>
                  <li><a status="5"><?php echo $filter_spam; ?></a></li>
                </ul>
              </div>
            </div>
            <div class="col-sm-6">
              <div class="input-group">
                <span class="input-group-addon"><i class="fa fa-search"></i></span>
                <input type="text" class="form-control" id="uvsearch" placeholder="<?php echo $entry_search; ?>">
              </div>
            </div>
          </div>
          <div class="table-responsive">
            <table class="table table-bordered table-hover">
              <thead>
                <tr>
                  <td class="text-center"><?php echo $column_ticket_no; ?></td>
                  <td class="text-center"><?php echo $column_subject; ?></td>
                  <td class="text-center"><?php echo $column_date_added; ?></td>
                  <td class="text-center"><?php echo $column_replies; ?></td>
                  <td class="text-center"><?php echo $column_agent; ?></td>
                </tr>
              </thead>
              <tbody id="ticketBody">
                <tr class="hide">
                  <td class="text-center" colspan="6"><?php echo $text_no_results; ?></td>
                </tr>
              </tbody>
              <tfoot><tr class="uvdesk-loader"><td colspan="6" class="alert alert-info text-center"><i class="fa fa-spin fa-spinner"></i></td></tr></tfoot>
              <tr class="text-center uvloader"><td colspan="6"><button class="btn btn-info" data-page="1"><?php echo $text_load_more; ?></button></td></tr>
            </table>
          </div>
          <div class="more">
          </div>
        </div>
      </div>
      <?php echo $content_bottom; ?></div>
    <?php echo $column_right; ?></div>
</div>
<script type="text/javascript">
  var next_page = 0, inprocess = 0, current_page = 0, last_page = 0;
  var uv_sort = '', uv_status = '', uv_order = 'DESC', uv_search = '';

  function getTickets() {
    next_page = parseInt(current_page) + 1;
    $.ajax({
      url: 'index.php?route=uvdesk/uvdesk/getTickets',
      dataType: 'json',
      type: 'post',
      data: {page: next_page, sort_by: uv_sort, status: uv_status, order: uv_order, search: uv_search},
      beforeSend: function () {
        $('.uvloader').addClass('hide');
        $('.uvdesk-loader').removeClass('hide');
        inprocess = 1;
      },
      success: function (json) {
        if (json['tickets']) {
          var jsonTickets = json['tickets'];
          var tickets = '';
          for (var i = 0; i < jsonTickets.length; i++) {
            tickets += '<tr class="viewTicket" ticket-id="' + jsonTickets[i]["ticket_id"] + '">';
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '">#' + jsonTickets[i]['ticket_id'] + '</a></td>';
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '"><i class="' + (jsonTickets[i]['attachments'] ? "fa fa-paperclip" : '') + '"></i> ' + jsonTickets[i]['subject'] + '</a></td>';
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '">' + jsonTickets[i]['date_added'] + '</a></td>';
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '"><span class="label label-info">' + jsonTickets[i]['threads'] + '</span></a></td>';
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '">';
            if(jsonTickets[i]['agent']) {
              tickets += jsonTickets[i]['agent'];
            } else {
              tickets += '      <span data-toggle="tooltip" title="<?php echo $text_no_agent; ?>" class=""><?php echo $text_unassigned; ?></span>';
            }
            tickets += '  </a></td>';
            tickets += '</tr>';
          }
          $('#ticketBody').append(tickets);
        } else {
          $('#ticketBody tr.hide').removeClass('hide');
        }
        current_page = json['current_page'];
        last_page = json['last_page']
        $('.uvloader').removeClass('hide');

        if (current_page == last_page) {
          $('.uvloader').addClass('hide');
        }

        if (tickets == '') {
          $('#ticketBody').append('<tr class="text-center"><td colspan="6"><?php echo $text_no_records; ?></td></tr>');
        }
      },
      complete: function () {
        $('.uvdesk-loader').addClass('hide');
        inprocess = 0;
      },
      error: function () {
        location.reload();
      }
    });
  }

  getTickets();

  $('body').on('click', '.viewTicket', function () {
    var ticket_id = $(this).attr('ticket-id');
    location = '<?php echo $ticket_url; ?>&id=' + ticket_id;
  });

  $('.uvstatus a').on('click', function () {
    var status = $(this).attr('status');
    if (status == uv_status) {
      if (uv_order == 'ASC') {
        uv_order = 'DESC';
      } else {
        uv_order = 'ASC';
      }
    } else {
      uv_status = status;
      uv_order = 'ASC';
    }
    uv_status = status;
    $('.uvstatus a').removeClass('uvfocus');
    $(this).addClass('uvfocus');
    $('#ticketBody').html('');
    current_page = 0;
    next_page = 0;
    getTickets();
  });

  $('.uvsort a').on('click', function () {
    var sort_by = $(this).attr('sort'), chevron = 'down';
    if (sort_by == uv_sort) {
      if (uv_order == 'ASC') {
        uv_order = 'DESC';
        chevron = 'up';
      } else {
        uv_order = 'ASC';
        chevron = 'down';
      }
    } else {
      uv_sort = sort_by;
      uv_order = 'ASC';
    }
    $('.sortChevron').remove();
    $(this).append(' <i class="fa fa-chevron-' + chevron + ' sortChevron"></i>');
    $('.uvsort a').removeClass('uvfocus');
    $(this).addClass('uvfocus');
    $('#ticketBody').html('');
    current_page = 0;
    next_page = 0;
    getTickets();
  });

  $('#uvsearch').on('keyup', function (e) {
    var thisthis = $(this);
    var regex = new RegExp("^[a-zA-Z0-9]+$");
    var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
    if (regex.test(str) || e.which == 8 || e.which == 13 || e.which == 46 || e.which == 32) {
      setTimeout(function () {
        if (!inprocess) {
          $('#ticketBody').html('');
          current_page = 0;
          next_page = 0;
          uv_search = thisthis.val();
          getTickets();
        }
      }, 1000);
    }
  });

  $('.uvloader button').on('click', function () {
    if (!(current_page == last_page)) {
      getTickets();
    }
  });
</script>
<?php echo $footer; ?> 