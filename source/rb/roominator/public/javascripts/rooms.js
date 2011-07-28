//Added by Oliver Sisson

function toggle_edit_row(i) {
  $('.edit_' + i).toggle();
  
  $('#text_r_number_' + i).val($('#label_r_number_' + i).text());
  $('#text_r_name_' + i).val(   $('#label_r_name_' + i).text());
  $('#text_c_id_' + i).val(     $('#label_c_id_' + i).text());
  $('#text_c_name_' + i).val(   $('#label_c_name_' + i).text());
}

function create_blank_row() {
  i = create_new_row("", "", "", "");
  toggle_edit_row(i);
  $('#cancel_link_' + i).hide();
}

function create_new_row(room_number, room_name, calendar_id, calendar_name) {
  var iteration = $("#rooms_table tr").length - 1;
  
  $("#rooms_table").append(
    "<tr id=row_" + iteration + ">" +
      "<td>" + // Room Number
        "<label name=\"label_r_number_" + iteration + "\" id=\"label_r_number_" + iteration + "\" class=\"edit_" + iteration + "\">" +
          room_number +
        "</label>" +
        "<input type=text name=\"text_r_number_" + iteration + "\" id=\"text_r_number_" + iteration + "\" class=\"edit_" + iteration + "\" value=\"" + room_number + "\"/ style=\"display:none\">" +
        "</input>" + 
      "</td>" + 
      "<td>" + // Room Name
        "<label name=\"label_r_name_" + iteration + "\" id=\"label_r_name_" + iteration + "\" class=\"edit_" + iteration + "\">" +
          room_name +
        "</label>" +
        "<input type=text name=\"text_r_name_" + iteration + "\" id=\"text_r_name_" + iteration + "\" class=\"edit_" + iteration + "\" value=\"" + room_name + "\"/ style=\"display:none\">" +
        "</input>" + 
      "</td>" +
      "<td>" + // Calendar ID
        "<label name=\"label_c_id_" + iteration + "\" id=\"label_c_id_" + iteration + "\" class=\"edit_" + iteration + "\">" +
          calendar_id +
        "</label>" +
        "<input type=text name=\"text_c_id_" + iteration + "\" id=\"text_c_id_" + iteration + "\" class=\"edit_" + iteration + "\" value=\"" + calendar_id + "\"/ style=\"display:none\">" +
        "</input>" + 
      "</td>" +
      "<td>" + // Calendar Name
        "<label name=\"label_c_name_" + iteration + "\" id=\"label_c_name_" + iteration + "\" class=\"edit_" + iteration + "\">" +
          calendar_name +
        "</label>" +
        "<input type=text name=\"text_c_name_" + iteration + "\" id=\"text_c_name_" + iteration + "\" class=\"edit_" + iteration + "\" value=\"" + calendar_name + "\"/ style=\"display:none\">" +
        "</input>" + 
      "</td>" +
      "<td>" + // Delete?
        "<input type=\"checkbox\" name=\"delete_" + iteration + "\" value=\"\"/>" +
      "</td>" +
      "<td>" + // Edit Room
        "<a name=\"edit_link_" + iteration + "\" id=\"edit_link_" + iteration + "\" class=\"edit_" + iteration + "\" href=\"#\" onclick=\"toggle_edit_row(" + iteration + ");\">"  +
          "Edit" +
        "</a>" + 
        "<a name=\"cancel_link_" + iteration + "\" id=\"cancel_link_" + iteration + "\" class=\"edit_" + iteration + "\" href=\"#\" onclick=\"toggle_edit_row(" + iteration + ");\" style=\"display:none\">"  +
          "Cancel" +
        "</a>" +
      "</td>" +
    "</tr>");
  
  $("#num_cols").val(iteration+1);
  return iteration;
}

//%th Room Number
//%th Room Name
//%th Calendar ID
//%th Calendar Name
//%th Edit Room
//%th Delete?