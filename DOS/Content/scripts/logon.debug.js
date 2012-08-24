$(document).ready(function () {

    if (getCookie('RememberMe') == "On") {
        $('#UserName').val($.cookie('UserName'));
        $('#Password').val($.cookie('Password'));
        $('#RememberMe').attr('checked', 'checked');

    }

    $('#submitFormButton').click(function () {
        if (jQuery.trim($('#UserName').val()).length > 0 && $('#Password').val().length > 0) {
            var userid = jQuery.trim($('#UserName').val());
            var password = "";
            if ($.cookie('Password') == $('#Password').val()) {
                password = $.cookie('Password');
            }
            else {
                password = hex_sha1($('#Password').val());
            }

            if ($("#RememberMe").is(':checked')) {
                $.cookie('UserName', userid, { expires: 365 });
                $.cookie('Password', password, { expires: 365 });
                $.cookie('RememberMe', 'On', { expires: 365 });
            }
            else {

                $.cookie('UserName', null);
                $.cookie('Password', null);
                $.cookie('RememberMe', null);
            }

            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "UserName", userid);
            createNewFormElement(submitForm, "Password", password);
            createNewFormElement(submitForm, "ReturnURL", $("#ReturnURL").val());

            submitForm.action = "/Account.mvc/LogOn";
            submitForm.Method = "POST";
            submitForm.submit();
        }
        else {
            alert("UserID and Password are mandatory.")
        }
    });
});