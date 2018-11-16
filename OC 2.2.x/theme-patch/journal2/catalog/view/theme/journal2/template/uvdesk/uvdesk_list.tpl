<?php echo $header; ?>
<link href="catalog/view/theme/default/stylesheet/uvdesk/list.css" rel="stylesheet" type="text/css" />
<div id="container" class="container j-container">
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
          <a href="<?php echo $create_ticket; ?>" class="button pull-right"><?php echo $button_create; ?></a>
        </div>
      <?php if (!$isTicketCustomer) { ?>
      </div>
      <?php return; } ?>
        <div class="panel-body" style="margin-bottom: 10px;">
          <div class="row uvrow width-100" style="display: inline-block;">
            <div class="col-sm-3" style="width: 24%; display: inline-block;">
              <select class="uvsort">
                <option value="t.id" class="uvfocus"><?php echo $sort_ticket_id; ?> <i class="fa fa-chevron-down sortChevron"></i></option>
                <option value="agentName"><?php echo $sort_agent_name; ?></option>
              </select>
            </div>
            <div class="col-sm-3" style="width: 24%; display: inline-block;">
              <select class="uvstatus">
                <option value="0" class="uvfocus"><?php echo $text_filter_by; ?></option>
                <option value="1"><?php echo $filter_open; ?></option>
                <option value="2"><?php echo $filter_pending; ?></option>
                <option value="6"><?php echo $filter_answered; ?></option>
                <option value="3"><?php echo $filter_resolved; ?></option>
                <option value="4"><?php echo $filter_closed; ?></option>
                <option value="5"><?php echo $filter_spam; ?></option>
              </select>
            </div>
            <div class="col-sm-6" style="width: 50%; display: inline-block;">
              <input type="text" class="form-control" id="uvsearch" placeholder="<?php echo $entry_search; ?>" style="border-radius: 20px;">
            </div>
          </div>
          <div class="table-responsive">
            <table class="table table-bordered table-hover list">
              <thead>
                <tr>
                  <td class="text-center"><?php echo $column_ticket_no; ?></td>
                  <td class="text-center"><?php echo $column_subject; ?></td>
                  <td class="text-center"><?php echo $column_date_added; ?></td>
                  <td class="text-center"><?php echo $column_status; ?></td>                  
                  <td class="text-center"><?php echo $column_replies; ?></td>
                  <td class="text-center"><?php echo $column_agent; ?></td>
                </tr>
              </thead>
              <tbody id="ticketBody">
                <tr class="hide" style="display: none;">
                  <td class="text-center" colspan="6"><?php echo $text_no_results; ?></td>
                </tr>
              </tbody>
              <tfoot><tr class="uvdesk-loader"><td colspan="6" style="text-align: center;"><i class="fa fa-spin fa-spinner"></i></td></tr></tfoot>
              <tr class="uvloader" style="text-align: center;"><td colspan="6"><button class="button" data-page="1"><?php echo $text_load_more; ?></button></td></tr>
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
        $('.uvloader').addClass('hide').css('display', 'none');
        $('.uvdesk-loader').removeClass('hide').css('display', '');
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
            tickets += '  <td class="text-center"><a href="<?php echo $ticket_url; ?>&id=' + jsonTickets[i]["ticket_id"] + '">' + jsonTickets[i]['status'] + '</a></td>';
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
          $('#ticketBody tr.hide').removeClass('hide').css('display', '');
        }
        current_page = json['current_page'];
        last_page = json['last_page']
        $('.uvloader').removeClass('hide').css('display', '');

        if (current_page == last_page) {
          $('.uvloader').addClass('hide').css('display', 'none');
        }

        if (tickets == '') {
          $('#ticketBody').append('<tr style="text-align: center;"><td colspan="6"><?php echo $text_no_records; ?></td></tr>');
        }
      },
      complete: function () {
        $('.uvdesk-loader').addClass('hide').css('display', 'none');
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

  $('.uvstatus').on('change', function () {
    var status = $(this).val();
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
    // $('.uvstatus a').removeClass('uvfocus');
    // $(this).addClass('uvfocus');
    $('#ticketBody').html('');
    current_page = 0;
    next_page = 0;
    getTickets();
  });

  $('.uvsort option').on('click', function () {
    var sort_by = $(this).val(), chevron = 'down';
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
    // $('.uvsort a').removeClass('uvfocus');
    // $(this).addClass('uvfocus');
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
