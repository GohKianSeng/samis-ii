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
    setSelectedDropDownlist("candidate_gender", getGenderValue());

    $(function () {
        $("#HistoryContent h3.expand").toggler();
        $("#HistoryContent div.HistoryDiv").expandAll({ trigger: "h3.expand", ref: "h3.expand" });
    });

    $('#candidate_dob').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });
    changeChurch();

    if (getMailingList() == "TRUE") {
        $('#mailingList').prop('checked', true);
    }
});

function setActiveTab(tabname) {
    if (tabname == "Personal Infomation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    else if (tabname == "History") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(1).addClass("active").show(); //Activate second tab
        $(".tab_content").eq(1).show(); //show the second tab
    }
    window.focus();
}

function checkAndSubmit() {

    var errormsg = "";

    if (jQuery.trim($('#candidate_english_name').val()).length == 0)
        errormsg += "- Name in English is mandatory\n";

    if (jQuery.trim($('#candidate_nric').val()).length == 0)
        errormsg += "- NRIC is mandatory\n";
    
    if (jQuery.trim($("#candidate_postal_code").val()).length > 0 && isNaN(jQuery.trim($("#candidate_postal_code").val())))
        errormsg += "- Postal Code is invalid\n";

    if (isValidEmailAddress(jQuery.trim($("#candidate_email").val())) == false && jQuery.trim($("#candidate_email").val()).length != 0) {
        errormsg += "- Email address is invalid";
    }

    else if (jQuery.trim($("#candidate_email").val()).length <= 0) {
        errormsg += "- Email address is mandatory\n";
    }

    if (jQuery.trim($('#candidate_contact').val()).length == 0)
        errormsg += "- Contact is mandatory\n";

    if (errormsg.length > 0) {
        alert(errormsg);
        return;
    }

    if (validateNRIC(jQuery.trim($("#candidate_nric").val().toUpperCase())) == false) {
        if (!confirm("NRIC, " + $("#candidate_nric").val() + ", entered seem to be invalid. Are you sure it is correct?")) {
            return;
        }
    }

    $("#" + getFormID()).submit();
}

function changeCourse() {
    $("#VisitorCaseTable").find("tr:gt(0)").remove();
    if (getCourseID().options[getCourseID().selectedIndex].value == 0)
        return;

    $.post("/membership.mvc/getCourseAttendance",
        { CourseID: getCourseID().options[getCourseID().selectedIndex].value, nric: getNRIC() },
        function (data) {
            parseCourseAttendance(data);
        }
    );
}

function parseCourseAttendance(data) {
    var xml = stringToXML(data);
    for (var x = 0; x < xml.getElementsByTagName("ATT").length; x++) {

        var table = document.getElementById("VisitorCaseTable");
        var row = table.insertRow(document.getElementById("VisitorCaseTable").rows.length);
        var percentage = xml.getElementsByTagName("ATT")[x].getElementsByTagName("AttendancePercentage")[0].childNodes[0].nodeValue;
        $("#AttendancePercentage").text(percentage + "%");

        fillCell(row, 0, xml.getElementsByTagName("ATT")[x].getElementsByTagName("Date")[0].childNodes[0].nodeValue);
        fillCell(row, 1, xml.getElementsByTagName("ATT")[x].getElementsByTagName("Attended")[0].childNodes[0].nodeValue);
    }
}

function changeChurch() {
    if ($("#" + getChurchByID()).val() == "28") {
        $("#church_others").show();
        $("#church_others").watermark("Name of church");
    }
    else {
        $("#church_others").val('');
        $("#church_others").hide();
    }
}