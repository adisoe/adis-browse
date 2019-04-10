<html>
  <% base_tag %>
  <head>

  </head>
  <body>
    <h3>Filter</h3>
    <div class="filter_container">
      <div class="filter_wrapper">
        <select name="filter[]" class="select_filter">
          <% loop Columns %>
          <option value="$Column" data-type="$Type">$Column</option>
          <% end_loop %>
        </select>
        <select name="filter_operator[]" class="select_filter_operator">  
          <option value="=" data-type="Number">=</option>  
          <option value="!=" data-type="Number"><></option>  
          <option value=">" data-type="Number">></option>  
          <option value=">=" data-type="Number">>=</option>  
          <option value="<" data-type="Number"><</option>  
          <option value="<=" data-type="Number"><=</option>  
          <option value="start" data-type="Text">Diawali dengan</option>  
          <option value="contain" data-type="Text">Mengandung</option>    
        </select>
        <input type="text" name="keyword[]" class="text_keyword"/>
      </div>
    </div>
    <button id="btn_add_filter">Add Filter</button>

    <h3>Sorting</h3>
    <select name="sorting" class="select_sorting">
      <% loop Columns %>
      <option value="$Column">$Column</option>
      <% end_loop %>
    </select>
    <select name="sorting_direction" class="select_sorting_direction">  
      <option value="ASC">ASC</option>
      <option value="DESC">DESC</option>  
    </select>

    <h3>Max Records</h3>
    <input type="text" name="count" class="text_count"/>

    <table id="table1">
      <tr>
        <% loop Columns %>
        <th>$Column</th>
        <% end_loop %>
      </tr>
    </table>

    <!--<span style="color:blue" onclick="returnYourChoice('Bob')">Halo, I am Bob =)</span>-->
    <script type="text/javascript">
      var ajax_data;
      // return the value to the parent window
      function returnYourChoice(choice) {
        opener.setWindowResult(choice);
        var win = window.open('', '_self');
        win.close();
        return true;
      }

      function doBrowse() {
        var arr_filter = [];
        $('.select_filter').each(function () {
          arr_filter.push($(this).val());
        });
        var arr_filter_operator = [];
        $('.select_filter_operator').each(function () {
          arr_filter_operator.push($(this).val());
        });
        var arr_keyword = [];
        $('.text_keyword').each(function () {
          arr_keyword.push($(this).val());
        });

        $.ajax({
          type: "POST",
          url: "browse/windowajax/$BrowseConfig",
          data: {
            "filter": arr_filter,
            "filter_operator": arr_filter_operator,
            "keyword": arr_keyword,
            "sorting": $('.select_sorting').val(),
            "sorting_direction": $('.select_sorting_direction').val(),
            "count": $('.text_count').val(),
          },
          dataType: "json",
          success: function (data) {
            ajax_data = data;
            //console.log(data);
            //alert(data);
            $('.row1').remove();
            var html = '';
            for (var i in data) {
              html += '<tr class="row1">';
              for (var key in data[i]) {
                //console.log(data[i]);
                //console.log(key);
                html += '<td>' + data[i][key] + '</td>';
              }
              html += '</tr>';
            }
            $('#table1').append(html);
          },
          error: function (xhr, ajaxOptions, thrownError) {
            alert(xhr.status+' '+thrownError);
          }
        });
      }

      (function ($) {
        doBrowse();

        $('body').on('change', '.select_filter, .text_keyword, .select_sorting, .select_sorting_direction, .text_count, .select_filter_operator', function () {
          doBrowse();
        });
        $('body').on('keyup', '.text_keyword, .text_count', function () {
          doBrowse();
        });

        // show only related operator
        $('body').on('change', '.select_filter', function () {
          var type = $('option:selected', this).attr('data-type');
          //alert("type:"+type);
          var select_operator = $(this).next('.select_filter_operator');
          select_operator.find('option').hide();
          select_operator.find('option').each(function () {
            var optionType = $(this).attr('data-type');
            //alert("optionType:"+optionType);
            if (optionType.indexOf(type) !== -1) {
              $(this).show();
            }
          });
        });

        $('#btn_add_filter').on('click', function () {
          var html = $('.filter_wrapper')[0].outerHTML;
          $('.filter_container').append(html);
        });

        $('body').on('click', '.row1', function () {
          //alert($(this).index());
          console.log(ajax_data[$(this).index() - 1]);
          console.log(opener);
          opener.setWindowResult(ajax_data[$(this).index() - 1]);
        });
      })(jQuery);
    </script>
  </body>
</html>



