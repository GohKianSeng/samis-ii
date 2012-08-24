$(document).ready(function () {

    $('#submitFormButton').click(function () {

        if ($('#oldPassword').val().length > 0 && $('#newPassword1').val().length > 0 && $('#newPassword2').val().length > 0) {
            
            if ($('#newPassword1').val() != $('#newPassword2').val()) {
                alert("New password does not match.");
                return;
            }

            if ($('#newPassword1').val().length < 5 || $('#newPassword2').val().length < 5) {
                alert("New password must be at least 6 characters.");
                return;
            }

            var oldpassword = hex_sha1($('#oldPassword').val());
            var newpassword1 = hex_sha1($('#newPassword1').val());

            $.cookie('UserName', null);
            $.cookie('Password', null);
            $.cookie('RememberMe', null);

            var submitForm = getNewSubmitForm();
            createNewFormElement(submitForm, "oldPassword", oldpassword);
            createNewFormElement(submitForm, "newPassword", newpassword1);
            createNewFormElement(submitForm, "confirmPassword", newpassword1);
            submitForm.action = "/Account.mvc/updateNewPassword";
            submitForm.Method = "POST";
            submitForm.submit();
        }
        else {
            alert("All fields are mandatory.")
        }

    });


});