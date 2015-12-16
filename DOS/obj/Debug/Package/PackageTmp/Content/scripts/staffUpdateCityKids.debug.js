$(document).ready(function () {
    $(".tab_content").hide(); //Hide all content
    setActiveTab("Personal Infomation");

    setTextAreaLengthLimit("kid_remarks");
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

    $(function () {
        $("#HistoryContent h3.expand").toggler();
        $("#HistoryContent div.HistoryDiv").expandAll({ trigger: "h3.expand", ref: "h3.expand" });
    });

    setSelectedDropDownlist("kid_transport", getTransport());    
});

function setActiveTab(tabname) {
    if (tabname == "Personal Infomation") {
        $("ul.tabs li").removeClass("active"); //Remove any "active" class
        $(".tab_content").hide(); //Hide all tab content
        $("ul.tabs li").eq(0).addClass("active").show(); //Activate first tab
        $(".tab_content").eq(0).show(); //show the first tab
    }
    window.focus();
}

function checkStaffKidsForm() {
    var errormsg = basicCheck();    

    if (errormsg.length > 0) {
        alert(errormsg);
        return;
    }

    if (validateNRIC(jQuery.trim($("#kid_nric").val().toUpperCase())) == false) {
        if (!confirm("NRIC, " + $("#kid_nric").val() + ", entered seem to be invalid. Are you sure it is correct?")) {
            return;
        }
    }

    $("#" + getFormID()).submit();

}