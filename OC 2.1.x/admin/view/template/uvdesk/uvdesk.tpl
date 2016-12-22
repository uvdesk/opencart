<?php echo $header; ?><?php echo $column_left; ?>
<div id="content">
  <div class="page-header">
    <div class="container-fluid">
      <h1><?php echo $heading_title; ?></h1>
      <ul class="breadcrumb">
        <?php foreach ($breadcrumbs as $breadcrumb) { ?>
        <li><a href="<?php echo $breadcrumb['href']; ?>"><?php echo $breadcrumb['text']; ?></a></li>
        <?php } ?>
      </ul>
      <?php if ($user_details) { ?>
      <div class="alert alert-info pull-right">
        <span class="round-tabs">
          <img class="border" src="<?php echo $user_details->pic; ?>">
        </span>
        <span class="name">
        <?php echo $user_details->name; ?>
        </span>
      </div>
      <?php } ?>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($error_warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-circle"></i> <?php echo $error_warning; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <?php if ($success) { ?>
    <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?>
      <button type="button" class="close" data-dismiss="alert">&times;</button>
    </div>
    <?php } ?>
    <div class="col-sm-3">
      <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title"><?php echo $text_labels; ?></h3></div>
        <div class="panel-body labels-body">
          <?php foreach ($predefined_labels as $key => $value) { ?>
          <a href="<?php echo $label_url . $key; ?>" style="<?php if ($label_active == $key) { echo "font-weight: 800; color: #333"; } else { echo "color: #555"; } ?>;"><?php echo ucfirst($key); ?> <span class="label label-success"><?php echo $value; ?></span></a><br>
          <?php } ?>
          <?php if ($custom_labels) { ?>
          <span id="moreLabel"><?php echo $text_more; ?> <span class="caret"></span></span><br>
          <div class="showLabel">
            <?php foreach ($custom_labels as $value) { ?>
            <a href="<?php echo $custom_label_url . $value->id; ?>" style="<?php if ($custom_label_active == $value->id) { echo "font-weight: 800; color: #333"; } else { echo "color: #555"; } ?>;"><?php echo ucfirst($value->name); ?> <span class="label label-success" style="background-color: <?php echo $value->color; ?>;"><?php echo $value->count; ?></span></a><br>
            <?php } ?>
          </div>
          <?php } ?>
        </div>
      </div>
      <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title"><?php echo $entry_filter_tickets; ?></h3></div>
        <div class="panel-body filters-body">
          <div>
            <label for="filter-assigned" class="control-label"><span data-toggle="tooltip" title="<?php echo $help_assigned; ?>"><?php echo $entry_assigned_to; ?></span></label>
            <br/>
            <div class="pos-relative" filter-type="agent">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_assigned; ?>" class="form-control inputbox" id="filter-assigned">
            </div>
          </div>
          <div>
            <label for="filter-customer" class="control-label"><span data-toggle="tooltip" title="<?php echo $help_customer; ?>"><?php echo $entry_customer; ?></span></label>
            <br/>
            <div class="pos-relative" filter-type="customer">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_customer; ?>" class="form-control inputbox" id="filter-customer">
            </div>
          </div>
          <div>
            <label for="filter-group"><?php echo $entry_group; ?></label>
            <br/>
            <div class="pos-relative" filter-type="group">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_group; ?>" class="form-control inputbox" id="filter-group">
            </div>
          </div>
          <div>
            <label for="filter-team"><?php echo $entry_team; ?></label>
            <br/>
            <div class="pos-relative" filter-type="team">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_team; ?>" class="form-control inputbox" id="filter-team">
            </div>
          </div>
          <div>
            <label for="filter-priority"><?php echo $entry_priority; ?></label>
            <br/>
            <div class="pos-relative" filter-type="priority">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_priority; ?>" class="form-control inputbox" id="filter-priority">
            </div>
          </div>
          <div>
            <label for="filter-type"><?php echo $entry_type; ?></label>
            <br/>
            <div class="pos-relative" filter-type="type">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_type; ?>" class="form-control inputbox" id="filter-type">
            </div>
          </div>
          <div>
            <label for="filter-tag" class="control-label"><span data-toggle="tooltip" title="<?php echo $help_tag; ?>"><?php echo $entry_tag; ?></span></label>
            <br/>
            <div class="pos-relative" filter-type="tag">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_tag; ?>" class="form-control inputbox" id="filter-tag">
            </div>
          </div>
          <div>
            <label for="filter-mailbox"><?php echo $entry_mailbox; ?></label>
            <br/>
            <div class="pos-relative" filter-type="mailbox">
              <i class="fa fa-spinner fa-spin"></i>
              <input type="text" placeholder="<?php echo $help_mailbox; ?>" class="form-control inputbox" id="filter-mailbox">
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="panel panel-default col-sm-9">
      <div class="panel-heading top-heading">
        <h3 class="panel-title"><i class="fa fa-list"></i> <?php echo $text_list; ?></h3>
        <div class="pull-right">
          <button type="button" data-toggle="tooltip" title="<?php echo $button_delete; ?>" class="btn btn-danger" onclick="confirm('<?php echo $text_confirm; ?>') ? $('#form-ticket').submit() : false;"><i class="fa fa-trash-o"></i></button>
        </div>
        <div class="col-sm-4 pull-right" style="">
          <div class="input-group">
            <input type="text" name="search" id="search" value="<?php echo $search; ?>" class="form-control" placeholder="<?php echo $entry_search; ?>">
            <span class="input-group-addon btn" id="search-btn"><i class="fa fa-search"></i></span>
          </div>
        </div>
      </div>
      <div id="ticket-list">
        <div class="panel-heading">
          <div class="btn-group width-100">
            <a class="btn btn-default width-16"><i class="fa fa-inbox"></i> <span class="hidden-xs"><?php echo $tab_open; ?></span><br><span class="label label-info">0</span></a>
            <a class="btn btn-default width-16"><i class="fa fa-exclamation-triangle"></i> <span class="hidden-xs"><?php echo $tab_pending; ?></span><br><span class="label label-info">0</span></a>
            <a class="btn btn-default width-16"><i class="fa fa-lightbulb-o"></i> <span class="hidden-xs"><?php echo $tab_answered; ?></span><br><span class="label label-info">0</span></a>
            <a class="btn btn-default width-16"><i class="fa fa-check-circle"></i> <span class="hidden-xs"><?php echo $tab_resolved; ?></span><br><span class="label label-info">0</span></a>
            <a class="btn btn-default width-16"><i class="fa fa-minus-circle"></i> <span class="hidden-xs"><?php echo $tab_closed; ?></span><br><span class="label label-info">0</span></a>
            <a class="btn btn-default width-16"><i class="fa fa-ban"></i> <span class="hidden-xs"><?php echo $tab_spam; ?></span><br><span class="label label-info">0</span></a>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  var inprocess = 0;
  $('body').prepend('<div class="loader-div"><div id="loader-div"></div><div class="cp-spinner cp-boxes"></div></div>');
  $('#moreLabel').on('click', function () {
    $('.showLabel').slideToggle();
  });
  $('#search').on('keyup', function (e) {
    if (e.which == 13) {
      search = $('#search').val();
      if (search) {
        setHash('search', search);
      } else {
        removeHash('search')
      }
      filteredData();
    }
  });
  $('#search-btn').on('click', function () {
    search = $('#search').val();
    setHash('search', search);
    filteredData();
  });

  if (localStorage) {
    localStorage.uvdesk_groups = '<?php echo $groups; ?>';
    localStorage.uvdesk_teams = '<?php echo $teams; ?>';
    localStorage.uvdesk_priorities = '<?php echo $priorities; ?>';
    localStorage.uvdesk_types = '<?php echo $types; ?>';
    localStorage.uvdesk_mailboxes = '<?php echo $mailboxes; ?>';
  };

  function fromLocalstorage(type) {
    var thisthis = $('#' + type);
    var data = '';
    var result_html = '';
    var length = 0;
    switch(type) {
      case 'filter-group':
        data = JSON.parse(localStorage.uvdesk_groups);
        break;
      case 'filter-team':
        data = JSON.parse(localStorage.uvdesk_teams);
        break;
      case 'filter-priority':
        data = JSON.parse(localStorage.uvdesk_priorities);
        break;
      case 'filter-type':
        data = JSON.parse(localStorage.uvdesk_types);
        break;
      case 'filter-mailbox':
        data = JSON.parse(localStorage.uvdesk_mailboxes);
        break;
    }
    length = Object.keys(data).length;
    if (length) {
      result_html += '<div class="uvdesk-dropdown">';
      result_html += '  <ul>';
      for (var i = 0; i < length; i++) {
        result_html += '  <li filter-id="' + data[i]['id'] + '">' + data[i]['name'] + '</li>';
      }
      result_html += '  </ul>';
      result_html += '</div>';
    }
    if (result_html == '') {
      result_html = '<div class="uvdesk-dropdown" style="display: block;"><span style="margin-left: 10px;">No Results</span></div>';
    }
    thisthis.after(result_html);
  }

  $('.inputbox').on('keyup click', function () {
    var thisthis = $(this);
    var type = thisthis.attr('id');

    if((type == 'filter-assigned' || type == 'filter-customer' || type == 'filter-tag')) { 
      if ((this.value).length < 2) {
        return;
      }
    } else {
      fromLocalstorage(type);
      return;
    }

    thisthis.prev().css('display', 'block');

    setTimeout(function () {
      filters(type, thisthis.val());
    }, 1000);
  });

  $('.inputbox').on('focusout', function () {
    $('.uvdesk-dropdown').slideUp();
  });

  function filters(type, value) {
    var thisthis = $('#' + type);

    if (type == 'filter-assigned' && localStorage && localStorage.uvdesk_members) {
      var members = JSON.parse(localStorage.uvdesk_members);
      var now = new Date().getTime();

      if ((members.timestamp + 900000) > now) {
        if (members.results) {
          var result_html = '';
          result_html += '<div class="uvdesk-dropdown">';
          result_html += '  <ul>';

          for (var i = 0; i < members.results.length; i++) {
            if (members.results[i]["title"].toLowerCase().search(value) != '-1') {
              result_html += '  <li filter-id="' + members.results[i]['id'] + '">' + members.results[i]['title'] + '</li>';
            }
          }
          result_html += '  </ul>';
          result_html += '</div>';
          thisthis.next('.uvdesk-dropdown').css('display', 'none');
          thisthis.after(result_html);
        }
        thisthis.prev().css('display', 'none');
        return;
      }
    }

    if (!inprocess) {
      $.ajax({
        url: 'index.php?route=uvdesk/uvdesk/getFilters&token=<?php echo $token; ?>&search=' + value,
        dataType: 'json',
        data: {url: '<?php echo $url; ?>', type: type},
        type: 'post',
        beforeSend: function () {
          $('.uvdesk-dropdown').remove();
          inprocess = 1;
        },
        success: function(json) {
          if (json['results']) {
            if (type == 'filter-assigned' && localStorage) {
              var uvdesk_members = {};
              uvdesk_members['results'] = json['results'];
              var now = new Date().getTime();
              uvdesk_members['timestamp'] = now;
              localStorage.uvdesk_members = JSON.stringify(uvdesk_members);
            }
            var result_html = '';
            result_html += '<div class="uvdesk-dropdown">';
            result_html += '  <ul>';

            for (var i = 0; i < json['results'].length; i++) {
              if (json['results'][i]["title"].toLowerCase().search(value) != '-1') {
                result_html += '  <li filter-id="' + json['results'][i]['id'] + '">' + json['results'][i]['title'] + '</li>';
              }
            }
            result_html += '  </ul>';
            result_html += '</div>';
            thisthis.after(result_html);
          }
          thisthis.prev().css('display', 'none');
          inprocess = 0;
        },
        error: function () {
          inprocess = 0;
        }
      });
    }
  };

  var status = 1, page = 1, search = '', scrollDown = 0, group = 0, team = 0, priority = 0, type = 0, mailbox = 0, tag = 0, tab = 1, agent = 0, customer = 0;

  function filteredData() {
    var data = {};
    data.page = page;
    data.search = search;
    data.status = status;
    if (group) {
      data.group = group;
    }
    if (team) {
      data.team = team;
    }
    if (priority) {
      data.priority = priority;
    }
    if (type) {
      data.type = type;
    }
    if (mailbox) {
      data.mailbox = mailbox;
    }
    if (tab) {
      data.tab = tab;
    }
    if (tag) {
      data.tag = tag;
    }
    if (agent) {
      data.agent = agent;
    }
    if (customer) {
      data.customer = customer;
    }

    if (!inprocess) {
      $.ajax({
        url: 'index.php?route=uvdesk/uvdesk/filteredTickets&token=<?php echo $token; ?><?php echo $url; ?>',
        dataType: 'html',
        data: data,
        type: 'get',
        beforeSend: function () {
          inprocess = 1;
          $('body .loader-div').css('display', 'block');
        },
        success: function(html) {
          $('body .loader-div').css('display', 'none');
          $('#ticket-list').html(html);

          setTimeout(function () {
            $('html, body').animate({ scrollTop: 130 }, 'slow');
          }, 500);
          $('.selectpicker').selectpicker('refresh');
          inprocess = 0;
        },
        error: function () {
          $('.loader-div').css('display', 'none');
          inprocess = 0;
        }
      });
    }
  };

  filteredData();

  $('#ticket-list').delegate('.pagination a', 'click', function(e) {
      e.preventDefault();
      
      $('body .loader-div').css('display', 'block');

      $('#ticket-list').load(this.href);

      setTimeout(function () {
        $('body .loader-div').css('display', 'none');
      }, 500);

      setTimeout(function () {
        $('html, body').animate({ scrollTop: 130 }, 'slow');
      }, 500);
  });

  $('#ticket-list').delegate('.panel-heading a', 'click', function(e) {
      var tab_id = $(this).attr('tab-id');

      if (tab_id == tab) {
        return;
      }

      tab = tab_id;

      setHash('tab', tab);
      filteredData();

      setTimeout(function () {
        $('html, body').animate({ scrollTop: 130 }, 'slow');
      }, 1000);
  });

  $('body').on('click', '.uvdesk-dropdown li', function () {
    var flag = true;
    var thisthis = $(this);
    var filter_id = thisthis.attr('filter-id');
    var drop_parent = thisthis.parent().parent().parent();
    var filter_type = drop_parent.attr('filter-type');

    eval("var filter_name = " + filter_type + ";");

    if (filter_name) {
      var prior_length = filter_name.length;
      if (prior_length > 1) {
        var prior = filter_name.split(',');
        for (var i = 0; i < prior_length; i++) {
          if (prior[i] == filter_id) {
            flag = false;
          }
        }
        if (flag) {
          eval(filter_type + " += ',' + '" + filter_id + "';");
        }
      } else {
        if (filter_name == filter_id) {
          flag = false;
        } else {
          eval(filter_type + " += ',' + '" + filter_id + "';");
        }
      }
    } else {
      eval(filter_type + " = '" + filter_id + "';");
    }

    if (flag) {
      thisthis.parent().parent().parent().before('<span class="label label-info">' + thisthis.text() + ' <i class="fa fa-times remove" filter-id="' + filter_id + '"></i></span> ');
      filteredData();
      drop_parent.children('input').val('');
      setHash(filter_type, eval(filter_type));
    }
  });

  function setHash(filter_type, filter_id) {
    var flag = true;
    var new_hash = '';
    var hash_url = window.location.hash.substr(1);
    if (!(hash_url == '')) {
      hash_url += '/';
    }
    var hash_array = hash_url.split('/');

    for (var i = 0; i < hash_array.length; i++) {
      if (hash_array[i] == filter_type) {
        hash_array[i+1] = filter_id;
        flag = false;
      }
      if (!(new_hash == '') && !(hash_array[i] == '')) {
        new_hash += '/' + hash_array[i];
      } else {
        new_hash += hash_array[i];
      }
    }

    if (flag) {
      window.location.hash = hash_url + filter_type + '/' + filter_id;
    } else {
      window.location.hash = new_hash;
    }
  }

  function removeHash(filter_type) {
    var new_hash = '';
    var hash_url = window.location.hash.substr(1);
    var hash_array = hash_url.split('/');

    for (var i = 0; i < hash_array.length; i++) {
      if (hash_array[i] == filter_type) {
        i++;
      } else {
        if (!(new_hash == '') && !(hash_array[i] == '')) {
          new_hash += '/' + hash_array[i];
        } else {
          new_hash += hash_array[i];
        }
      }
    }
    window.location.hash = new_hash;
  }

  $('body').on('click', '.remove', function () {
    var filter_id = $(this).attr('filter-id');
    var filter_type = $(this).parent().parent().children('.pos-relative').attr('filter-type');
    var filter_value = '';
    eval("var filter_name = " + filter_type + ";");
    var filter_len = filter_name.length;
    if (filter_len > 1) {
      var filter = filter_name.split(',');
      for (var i = 0; i < filter.length; i++) {
        if (!(filter[i] == filter_id)) {
          if (filter_value == '') {
            filter_value = filter[i];
          } else {
            filter_value += ',' + filter[i];
          }
        }
      }
      eval(filter_type + " = '" + filter_value + "';");
    } else {
      eval(filter_type + " = 0;");
    }
    filteredData();
    if(filter_value) {
      setHash(filter_type, filter_value);
    } else {
      removeHash(filter_type);
    }
    $(this).parent().remove();
  });

  $('body').on('click', '.text-left .badge, .text-left .btn-primary', function () {
    var ht = $(this).next().html();
    var element = $(this);

    setTimeout(function() {
      element.parent().find('.dropdown-toggle').trigger("click");
    }, 50);

    if (localStorage && localStorage.uvdesk_members) {
      var members = JSON.parse(localStorage.uvdesk_members);
      var now = new Date().getTime();

      if ((members.timestamp + 900000) > now) {
        if (members.results) {
          var result_html = '';

          for (var i = 0; i < members.results.length; i++) {
              result_html += '  <option filter-id="' + members.results[i]['id'] + '">' + members.results[i]['title'] + '</option>';
          }
          $('#ticket-list .selectpicker').html(result_html);
          $('.selectpicker').selectpicker('refresh');
        }
        return;
      }
    }

    if (!inprocess) {
      $.ajax({
        url: 'index.php?route=uvdesk/uvdesk/getFilters&token=<?php echo $token; ?>&search=',
        dataType: 'json',
        data: {type: 'filter-assigned'},
        type: 'post',
        beforeSend: function () {
          inprocess = 1;
        },
        success: function(json) {
          if (json['results']) {
            if (localStorage) {
              var uvdesk_members = {};
              uvdesk_members['results'] = json['results'];
              var now = new Date().getTime();
              uvdesk_members['timestamp'] = now;
              localStorage.uvdesk_members = JSON.stringify(uvdesk_members);
            }
            var result_html = '';
            result_html += '<div class="uvdesk-dropdown">';
            result_html += '  <ul>';

            for (var i = 0; i < json['results'].length; i++) {
              result_html += '  <option filter-id="' + json['results'][i]['id'] + '">' + json['results'][i]['title'] + '</option>';
            }
            result_html += '  </ul>';
            result_html += '</div>';
            $('#ticket-list .selectpicker').html(result_html);
            $('.selectpicker').selectpicker('refresh');
          }
          inprocess = 0;
        },
        error: function () {
          inprocess = 0;
        }
      });
    }
  });

  $('body').on('click', '#ticket-list .dropdown-menu li', function () {
    var thisthis = $(this);
    var thisparent = thisthis.parent().parent().parent().parent();
    var agent_index = thisthis.attr('data-original-index');
    var ticket_id = thisparent.attr('ticket-id');
    var pre_agent_id = thisparent.attr('agent-id');
    var agent_id = 0;
    var agent_name = '';

    if (localStorage && localStorage.uvdesk_members) {
      var agents = JSON.parse(localStorage.uvdesk_members);
      agent_id = agents['results'][agent_index]['id'];
      agent_name = agents['results'][agent_index]['title'];
    }

    if (agent_id && !(agent_id == pre_agent_id)) {
      $.ajax({
        url: 'index.php?route=uvdesk/uvdesk/assignAgent&token=<?php echo $token; ?>',
        dataType: 'json',
        data: {ticket_id: ticket_id, agent_id: agent_id},
        type: 'post',
        beforeSend: function () {
          $('.alert').remove();
          $('body .loader-div').css('display', 'block');
        },
        success: function(json) {
          $('body .loader-div').css('display', 'none');
          if (json['success']) {
            setTimeout(function () {
              $('html, body').animate({ scrollTop: 30 }, 'slow');
            }, 500);
            $('.container-fluid:last').prepend('<div class="alert alert-success"><i class="fa fa-check-circle"></i> ' + json['success'] + '<button type="button" class="close" data-dismiss="alert">&times;</button></div>');
            if (thisparent.children('.addAgent').hasClass('addAgent')) {
              thisparent.children('.addAgent').remove();
              thisparent.prepend('<span class="badge"><i class="fa fa-pencil"></i></span> <span class="agentName">' + agent_name + '</span>');
            } else {
              thisparent.children('.agentName').text(agent_name);
            }
          }
        }
      });
    }
  });
</script>
<?php echo $footer; ?>