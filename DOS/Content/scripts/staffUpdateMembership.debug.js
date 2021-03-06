﻿$(document).ready(function () {
    $(".tab_content").hide(); //Hide all content
    setActiveTab("Personal Infomation");

    setTextAreaLengthLimit("candidate_street_address");

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

    $(".multiple_select_ministry").multiselect({ minWidth: 'auto', selectedList: 3, HideCheckAll: true, multiple: true, selectedText: "# of # selected" }).multiselectfilter();

    $('#candidate_electoralroll_date').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    $('#candidate_transfertodate').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    $('#candidate_DeceasedDate').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });

    $('#candidate_MemberDate').datepick({ yearRange: getDateRangeString(), maxDate: +0, dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
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

    $("#candidate_Filename").change(function () {
        var fileName = $(this).val();
        if (!validateFile(fileName)) {
            alert("Cannot upload this file, " + fileName + ". Select again!");
            $(this).val("")
        }
    });

    loadAttachment();
    if (canUpdate() == "False") {
        document.getElementById('filecanupdate').style.display = "none";
    }
});

function validateFile(filename) {
    var file = getAcceptedFile().split(",");
    for (var x = 0; x < file.length; x++) {
        if (endsWith(filename, file[x]))
            return true;
    }
    return false;
}

function endsWith(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
}

function changeCourse() {
    $("#MemberCaseTable").find("tr:gt(0)").remove();
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
        
        var table = document.getElementById("MemberCaseTable");
        var row = table.insertRow(document.getElementById("MemberCaseTable").rows.length);
        var percentage = xml.getElementsByTagName("ATT")[x].getElementsByTagName("AttendancePercentage")[0].childNodes[0].nodeValue;
        $("#AttendancePercentage").text(percentage + "%");

        fillCell(row, 0, xml.getElementsByTagName("ATT")[x].getElementsByTagName("Date")[0].childNodes[0].nodeValue);
        fillCell(row, 1, xml.getElementsByTagName("ATT")[x].getElementsByTagName("Attended")[0].childNodes[0].nodeValue);
    }
}

function setActiveTab(tabname) {
    if (tabname == "Personal Infomation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    else if (tabname == "Baptism/Confirmation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(1).addClass("active").show(); //Activate second tab
        $(".tab_content").eq(1).show(); //show the second tab
    }
    window.focus();
}

function loadAttachment() {
    $.post("/membership.mvc/getUploadedAttachment",
        { nric: getNRIC() },
        function (data) {
            parseAttachment(data);
        }
    );
}

function parseAttachment(data) {
    $("#fileAttachment").find("tr:gt(0)").remove();
    var xml = stringToXML(data);
    for (var x = 0; x < xml.getElementsByTagName("Attachment").length; x++) {

        var table = document.getElementById("fileAttachment");
        var row = table.insertRow(document.getElementById("fileAttachment").rows.length);

        if (canUpdate() == "True")
            fillCell(row, 0, '<img onclick="removeAttachment(' + xml.getElementsByTagName("Attachment")[x].getElementsByTagName("AttachmentID")[0].childNodes[0].nodeValue + ', \'' + xml.getElementsByTagName("Attachment")[x].getElementsByTagName("Filename")[0].childNodes[0].nodeValue + '\', \'' + xml.getElementsByTagName("Attachment")[x].getElementsByTagName("GUID")[0].childNodes[0].nodeValue + '\');" border="0" src="/Content/images/remove.png" width="20" height="20" style="cursor:pointer" title="Add"  alt="Add"/>');
        else
            fillCell(row, 0, '&nbsp');
        fillCell(row, 1, xml.getElementsByTagName("Attachment")[x].getElementsByTagName("DATE")[0].childNodes[0].nodeValue);
        fillCell(row, 2, xml.getElementsByTagName("Attachment")[x].getElementsByTagName("FileType")[0].childNodes[0].nodeValue);
        if (xml.getElementsByTagName("Attachment")[x].getElementsByTagName("Remarks")[0].childNodes.length > 0) {
           fillCell(row, 3, xml.getElementsByTagName("Attachment")[x].getElementsByTagName("Remarks")[0].childNodes[0].nodeValue);
       }
       else
           fillCell(row, 3, '<label />');
        fillCell(row, 4, '<a href="/uploadfile.mvc/downloadAttachment?guid=' + escape(xml.getElementsByTagName("Attachment")[x].getElementsByTagName("GUID")[0].childNodes[0].nodeValue) + '&filename=' + escape(xml.getElementsByTagName("Attachment")[x].getElementsByTagName("Filename")[0].childNodes[0].nodeValue) + '" >' + xml.getElementsByTagName("Attachment")[x].getElementsByTagName("Filename")[0].childNodes[0].nodeValue + '</a>');
        
    }
} 

function removeAttachment(id, filename, guid){
    var r = confirm("Are you sure you want to permanently delete '" + filename + "'?\n\n *This action cannot be undo.");
    if (r == false)
        return;
    $.post("/uploadfile.mvc/removeAttachment",
        { id: id, filename: filename, guid: guid },
        function (data) {
            if (jQuery.trim(data) != "OK")
                alert(data);
            loadAttachment();
        }
    );
}


function checkStaffMemberForm() {
    var errormsg = basicCheck();

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