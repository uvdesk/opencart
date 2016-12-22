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
      <?php if (isset($ticket->userDetails)) { ?>
      <div class="alert alert-info pull-right">
        <span class="round-tabs">
          <img class="border" src="<?php echo $ticket->userDetails->pic; ?>">
        </span>
        <span class="name">
        <?php echo $ticket->userDetails->name; ?>
        </span>
      </div>
      <?php } ?>
    </div>
  </div>
  <div class="container-fluid">
    <?php if ($success) { ?>
    <div class="alert alert-success"><i class="fa fa-check-circle"></i> <?php echo $success; ?></div>
    <?php } ?>
    <?php if ($warning) { ?>
    <div class="alert alert-danger"><i class="fa fa-exclamation-triangle"></i> <?php echo $warning; ?></div>
    <?php } ?>
    <div class="col-sm-3">
      <div class="panel panel-default">
        <div class="panel-heading"><h3 class="panel-title"><?php echo $text_labels; ?></h3></div>
        <div class="panel-body">
          <?php if (isset($predefined_labels)) { ?>
          <?php foreach ($predefined_labels as $key => $value) { ?>
          <a href="<?php echo $label_url . $key; ?>" style="<?php if ($label_active == $key) { echo "font-weight: 800; color: #333"; } else { echo "color: #555"; } ?>;"><?php echo ucfirst($key); ?> <span class="label label-success"><?php echo $value; ?></span></a><br>
          <?php } ?>
          <?php } ?>
          <?php if (isset($custom_labels) && $custom_labels) { ?>
          <span id="moreLabel"><?php echo $text_more; ?> <span class="caret"></span></span><br>
          <div class="showLabel">
            <?php foreach ($custom_labels as $value) { ?>
            <a href="<?php echo $custom_label_url . $value->id; ?>" style="<?php if ($custom_label_active == $value->id) { echo "font-weight: 800; color: #333"; } else { echo "color: #555"; } ?>;"><?php echo ucfirst($value->name); ?> <span class="label label-success" style="background-color: <?php echo $value->color; ?>;"><?php echo $value->count; ?></span></a><br>
            <?php } ?>
          </div>
          <?php } ?>
        </div>
      </div>
    </div>
    <div class="panel panel-default col-sm-9">
      <div id="ticket-detail">
        <h3 class="pull-left">
          #<?php 
          if (isset($ticket->ticket->incrementId)) {
            echo $ticket->ticket->incrementId;
            echo " ";
          }
          if (isset($ticket->ticket->subject)) {
            echo $ticket->ticket->subject;
          }
           ?>
        </h3>
        <div style="clear: both;">
          <?php if (isset($ticket->ticket->status->id)) { ?>
          <span class="label label-info" title="Status" data-toggle="tooltip"><?php echo $ticket->ticket->status->name; ?></span>
          <?php } ?>
          <?php if (isset($ticket->ticket->priority->id)) { ?>
          <span class="label label-warning" title="Priority" data-toggle="tooltip"><?php echo $ticket->ticket->priority->name; ?></span>
          <?php } ?>
          <?php if (isset($ticket->ticket->type->id)) { ?>
          <span class="label label-info" title="Type" data-toggle="tooltip"><?php echo $ticket->ticket->type->name; ?></span>
          <?php } ?>
          <span class="label label-info" title="Threads" data-toggle="tooltip"><?php echo $ticket->ticketTotalThreads; ?></span>
          <span class="label label-success" title="Agent" data-toggle="tooltip"><i class="fa fa-user"></i></span>
          <span>
          <?php if (isset($ticket->ticket->agent->detail->agent->id)) {
            $agent_name = $ticket->ticket->agent->detail->agent->name;
            echo $ticket->ticket->agent->detail->agent->firstName;
          } else {
            $agent_name = '';
          } ?>
          </span>
        </div>
      </div>
      <div class="thread">
        <div class="col-sm-12 thread-created-info text-center">
          <span class="info">
          <?php if (isset($ticket->ticket->customer->detail->customer->id)) {
            $customer_name = $ticket->ticket->customer->detail->customer->name;
            $customer_email = $ticket->ticket->customer->email;
            echo $customer_name;
          } else {
            $customer_name = '';
            $customer_email = '';
          } ?>
            <?php echo $text_created; ?>
          </span>
          <span class="text-right date pull-right">
            <?php if (isset($ticket->ticket->formatedCreatedAt)) {
              echo $ticket->ticket->formatedCreatedAt;
            } ?>
          </span>
        </div>
        <div class="col-sm-12">
          <div class="pull-left">
            <span class="round-tabs">
              <img src="<?php if (isset($ticket->ticket->customer->profileImage)) { echo $ticket->ticket->customer->profileImage; } else { echo "https://cdn.uvdesk.com/uvdesk/images/d94332c.png"; } ?>">
            </span>
          </div>
          <div class="thread-info">
            <div class="thread-info-row first">
              <span class="cust-name">  
                <strong><?php echo $customer_name; ?> ( <?php echo $customer_email; ?> ) </strong>
              </span>
            </div>
            <div class="thread-info-row">
            </div>
          </div>
          <div class="thread-body">
            <div class="reply border-none">
              <div class="main-reply">
                <?php if (isset($ticket->createThread->reply)) {
                  echo $ticket->createThread->reply;
                } ?>
              </div>
              <?php if (isset($ticket->createThread->attachments) && $ticket->createThread->attachments) { ?>
                <?php foreach ($ticket->createThread->attachments as $attachment) { ?>
                  <a href="<?php echo $attachment_url . $attachment->id; ?>" target="_blank" class="download-attachment"><i class="fa fa-download"></i></a>
                <?php } ?>
              <?php } ?>
            </div>
          </div>
        </div>
      </div>

      <div class="text-center expand-div">
        <button class="btn btn-primary" id="button-load"><?php echo $text_expand_more; ?></button>
        <span class="loader-border"></span>
      </div>

      <div class="ticket-thread">
      </div>
      <hr>
      <div class="col-sm-12">
        <div class="pull-left">
          <span class="round-tabs">
            <?php if (isset($ticket->userDetails->pic) && $ticket->userDetails->pic) { ?>
            <img src="<?php echo $ticket->userDetails->pic; ?>">              
            <?php } else { ?>
            <img src="https://cdn.uvdesk.com/uvdesk/images/d94332c.png">
            <?php } ?>
          </span>
        </div>
        <span class="userName"><?php echo $ticket->userDetails->name; ?></span>
        <div class="thread-body">
          <div class="thread-info">
            <!-- <br><br> -->
            <form action="<?php echo $add_reply; ?>" method="post" enctype="multipart/form-data">
              <div class="reply border-none">
                <textarea class="summernote" name="reply"></textarea>
                <input type="hidden" name="ticket_id" value="<?php echo $thread_id; ?>">
                <input type="hidden" name="id" value="<?php echo $id; ?>">
                <div class="attachment-div">
                  <span class="download-attachment upload-attachment"><i class="fa fa-upload"></i><span onclick="$(this).parent().parent().remove();">&times;</span></span>
                  <input type="file" name="attachment[]" class="fileUpload" onchange="fileupload(this);">
                </div>
                <span id="addFile">+ <?php echo $text_attach_file; ?></span>
                <br><br>
                <input type="submit" class="btn btn-success" value="Reply">
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
<script type="text/javascript">
  var current_page = 0;
  var last_page = 0;
  var inprocess = 0, scrollDown = 1;

  $('#moreLabel').on('click', function () {
    $('.showLabel').slideToggle();
  });

  $('.summernote').summernote({height: 300});

  function loadThreads() {
    var next_page = parseInt(current_page) + 1;
    
    $.ajax({
      url: 'index.php?route=uvdesk/uvdesk/getThreads&token=<?php echo $token; ?>',
      dataType: 'json',
      type: 'post',
      data: {id: '<?php if (isset($thread_id)) echo $thread_id; else echo ""; ?>', page: next_page},
      beforeSend: function () {
        $('#button-load').html('<i class="fa fa-spin fa-spinner"></i>');
        $('#button-load').addClass('disabled');
        inprocess = 1;
      },
      success: function (json) {
        var threads = '';
        if (json['threads']) {
          var jsonThreads = json['threads'];
          for (var i = 0; i < jsonThreads.length; i++) {
            var threads = '';
            threads += '<div class="thread">';
            threads += '  <div class="col-sm-12 thread-created-info text-center">';
            threads += '    <span class="info">';
            threads += '      <span id="thread' + jsonThreads[i]['thread_id'] + '" class="copy-thread-link">#' + jsonThreads[i]['thread_id'] + '</span>';
            threads += '      ' + jsonThreads[i]['name'];
            threads += '      <?php echo $text_replied; ?>';
            threads += '    </span>';
            threads += '    <span class="text-right date pull-right">';
            threads += jsonThreads[i]['date_added'];
            threads += '    </span>';
            threads += '  </div>';
            threads += '  <div class="col-sm-12">';
            threads += '    <div class="pull-left">';
            threads += '      <span class="round-tabs">';
            threads += '        <img src="' + jsonThreads[i]['thumbnail'] + '">';
            threads += '      </span>';
            threads += '    </div>';
            threads += '    <div class="thread-body">';
            threads += '      <div class="thread-info">';
            threads += '        <div class="thread-info-row first">';
            threads += '          <span class="cust-name">  ';
            threads += '            <strong>' + jsonThreads[i]['name'] + '</strong>';
            threads += '          </span>';
            threads += '          <label class="user-type customer label label-info">';
            threads += jsonThreads[i]['user_type'];
            threads += '          </label>';
            // threads += '          <div class="thread-actions pull-right">';
            // threads += '            <i class="fa fa-star" data-toggle="tooltip" data-placement="top" data-original-title="Bookmark"></i>';
            // threads += '            <i class="fa fa-share" data-toggle="tooltip" data-placement="top" data-original-title="Forward"></i>';
            // threads += '            <i class="fa fa-lock" data-toggle="tooltip" data-placement="top" data-original-title="Lock"></i>';
            // threads += '            <i class="fa fa-tasks" data-toggle="tooltip" data-placement="top" data-original-title="Mark for Task"></i>';
            // threads += '            <i class="fa fa-pencil" data-toggle="tooltip" data-placement="top" data-original-title="Edit"></i>';
            // threads += '            <i class="fa fa-trash" data-toggle="tooltip" data-placement="top" data-original-title="Delete"></i>';
            // threads += '          </div>';
            threads += '        </div>';
            threads += '        <div class="thread-info-row">';
            threads += '        </div>';
            threads += '      </div>';
            threads += '      <div class="reply">';
            threads += '        <div class="main-reply">';
            threads += '          ' + jsonThreads[i]['reply'];
            threads += '        </div>';
            threads += '      </div>';
            var attachment_length = Object.keys(jsonThreads[i]['attachments']).length;
            if (attachment_length) {
              threads += '<div class="attachments">';
              for (var j = 0; j < attachment_length; j++) {
                threads += '<a href="<?php echo $attachment_url; ?>' + jsonThreads[i]['attachments'][j]['id'] + '" target="_blank" class="download-attachment"><i class="fa fa-download"></i></a>';
              }
              threads += '</div>';
            }
            threads += '    </div>';
            threads += '  </div>';
            threads += '</div>';
            threads += '<hr>';
            $('.ticket-thread').prepend(threads);
          }
        }
        current_page = json['current_page'];
        last_page = json['last_page']

        if (current_page == last_page) {
          $('#button-load').text('<?php echo $text_all_expand; ?>');
        } else {
          var threads_left = json['total'] - (10 * current_page);
          $('#button-load').text('<?php echo $text_expand; ?> ' + threads_left + ' <?php echo $text_more; ?>');
        }
        inprocess = 0;
        if (scrollDown) {
          var docheight = ($(document).height() - $(window).height() - 230);
          $('html, body').animate({ scrollTop: docheight }, 'slow');
          scrollDown = 0;
        }
      },
      complete: function () {
        $('#button-load').removeClass('disabled');
      },
      error: function () {
        
      }
    });
  }

  $('#button-load').on('click', function () {
    if (!inprocess && last_page > current_page) {
      loadThreads();
    }
  })

  loadThreads();

  $('body').on('click', '.upload-attachment', function () {
    var child = $(this).next('.fileUpload');
    child.trigger('click');
  });

  function fileupload(thisthis) {
    var size = thisthis.files[0].size/1000;
    var limit = 1;
    var max = 10;
    var maxsize = <?php echo $size;?>;
    // var allowed_extensions = <?php echo json_encode($extensions);?>;
    if(thisthis.type == 'file') {
      fileName = thisthis.value;
      var file_extension = fileName.split('.').pop(); 
      // for(var i = 0; i <= allowed_extensions.length && limit <= max; i++) {
        if(size < maxsize) {
          var getImagePath = URL.createObjectURL(thisthis.files[0]);
          $(thisthis).prev().css('background-image', 'url(' + getImagePath + ')');
          $(thisthis).prev().css('background-size', 'cover');
          // $(thisthis).prev().append('<span class="ex">' + file_extension + '</span>');
          limit++;
          return true; 
        }
      // }
    }
    if(limit > max)
      alert('Maximum Number of file is ' + max);
    else
      alert("Invalid file type or size");
      thisthis.value = "";
      return false;
  };

  $('#addFile').on('click', function () {
    var attach = '<div class="attachment-div"><span class="download-attachment upload-attachment"><i class="fa fa-upload"></i><span onclick="$(this).parent().parent().remove();">&times;</span></span><input type="file" name="attachment[]" class="fileUpload" onchange="fileupload(this);"></div>';
    $(this).before(attach);
  });

</script>
<?php echo $footer; ?>