$(document).ready(function () {
    $('#kidschedule').datepick({ monthsToShow: 4, multiSelect: 999, minDate: '-0d', maxDate: '+1y', dateFormat: 'dd/mm/yyyy', pickerClass: 'datepick-jumps',
        renderer: $.extend({}, $.datepick.defaultRenderer,
        { picker: $.datepick.defaultRenderer.picker.
            replace(/\{link:prev\}/, '{link:prevJump}{link:prev}').
            replace(/\{link:next\}/, '{link:nextJump}{link:next}')
        })
    });
});