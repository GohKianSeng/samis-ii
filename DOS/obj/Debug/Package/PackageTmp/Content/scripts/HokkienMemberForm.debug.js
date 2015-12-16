$(document).ready(function () {
    $(".tab_content").hide(); //Hide all content
    setActiveTab("Personal Infomation");

    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(this).addClass("active"); //Add "active" class to selected tab
        $(".tab_content").hide(); //Hide all tab content
        var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
        $(activeTab).fadeIn(); //Fade in the active content
        //$(activeTab).show(); 
        window.focus();
        return false;
    });

    $("table").tablesorter({ dateFormat: "uk" });
    $(".tablesorter tr:even").addClass("alt");

    $('#DOB').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    $(function () {
        $("#HistoryContent h3.expand").toggler();
        $("#HistoryContent div.HistoryDiv").expandAll({ trigger: "h3.expand", ref: "h3.expand" });
    });

    uploader = new qq.FileUploader({
        element: document.getElementById('candidate_photofile'),
        action: '/uploadfile.mvc/SaveFile',
        allowedExtensions: ['jpg', 'jpeg', 'jpe', 'png', 'gif'],
        sizeLimit: 100000,
        params: {
            guid: getGUID()
        },
        onComplete: function (id, fileName, responseJSON) {
            if (jQuery.trim(responseJSON) == "1") {
                reloadICPhoto(fileName, getGUID());
                $("#candidate_photo").val(getGUID() + "_" + fileName);
            }
        }
    });

    if (getMesssage().length > 0) {
        alert(getMesssage());
    }

    if ($("#candidate_photo").val().length > 0) {
        var nameguid = $("#candidate_photo").val().split('_');
        reloadICPhoto(nameguid[1], nameguid[0]);
        
    }

    if (changeType() == "Modify") {
        $("#registration_form").get(0).setAttribute('action', '/hws.mvc/updateMember');
    }
});

function reloadICPhoto(filename, guid) {
    $('#icphoto').attr('src', '/uploadfile.mvc/downloadPhoto?guid=' + guid + '&filename=' + escape(filename) + '&random=' + Math.random());
}

function setActiveTab(tabname) {
    if (tabname == "Personal Infomation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    window.focus();
}

function checkForm() {
    var errormsg = "";
    if ($("#EnglishGivenName").val().length <= 0 && $("#ChineseGivenName").val().length <= 0) {
        errormsg += "Enter at least English Given Name or Chinese Given Name."
    }

    return errormsg;
}

function checkHWSMemberFormNew() {
    var errormsg = checkForm();
    if (errormsg.length < 0) {
        alert(errormsg);
        return;
    }
    $("#registration_form").submit();
}