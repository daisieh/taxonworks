function destroy_record(rf_link) {
    // do something to the html
    $(rf_link).prev('.destroy_field').attr('value', '1');
    $(rf_link).closest('.fields').hide();
}

function edit_record(ef_link) {
    // do something to the html
    $(ef_link).prev('.edit_field').attr('value', '1');
    $(ef_link).closest('.fields').hide();
}

function add_fields(af_link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(af_link).prev().insertBefore(content.replace(regexp, new_id));
}

function a_fields(af_link) {
//    af_link.attributes.content.value or $(af_link).attr('content')
    var content = $(af_link).attr('content');
    var association = $(af_link).attr('association');
    var new_id = new Date().getTime();
    var regex = new RegExp("new_" + association, "g");
    content = content.replace(regex, new_id);
    $(content).insertBefore($(af_link));
}

$(document).on('ready page:load', function() {
    $(".alternate-value-edit").click(function(event) {
        edit_record(this);
        event.preventDefault();
    });
    return $(".alternate-value-destroy").click(function(event) {
        destroy_record(this);
        event.preventDefault();
    });
});
