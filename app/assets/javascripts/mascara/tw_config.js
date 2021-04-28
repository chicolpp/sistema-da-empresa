var TwConfig = {
	cut_string: function(str, size){
		var str_format;
		if(str != undefined && size != undefined){
			str_format = jQuery.trim(str).substring(0, size).trim(this) + "..."
			str_format = ((str_format.length - 3) == str.length) ? str : str_format;
			return str_format;
		}
	},
	datepicker: {
		options: function(){
			return {
				dateFormat: 'dd/mm/yy',
				// showOn: "never",
				autoSize: false,
				buttonText: '',
				changeYear: true,
				changeMonth: true,
				showButtonPanel: true,
				controlType: 'select',
				// É verificado se é clique duplo, fecha o datepicker
				onSelect: function(val, t){
					if (!t.clicks) t.clicks = 0;
					if (++t.clicks === 2) {
			             t.inline = false;
			             t.clicks = 0;
			         }
			         setTimeout(function (){
			             t.clicks = 0
			         }, 500);
				}
			}
		},
		apply: function(element){
			element = $(element);
			var type = element.data('type') || 'd';
			if(type == 'dh'){
				element.datetimepicker(TwConfig.datepicker.options());
				element.mask('99/99/9999 00:00:00');
				element.attr('placeholder','Ex: 01/01/2016 23:59:59');
			}else{
				element.datepicker(TwConfig.datepicker.options());
				element.mask('99/99/9999');
				element.attr('placeholder','Ex: 01/01/2016');
			}
			element.parents('.input-group:first').find('span').on('click', function(event) {
				$(this).datepicker('show');
			});
			element.on('dblclick', function(event) {
				$(this).datepicker('show');
			});
			element.bind('keydown', function(event) {
				if(event.keyCode == 68 || event.keyCode == 107){
					element.datepicker('show');
				}
				if(event.keyCode == 109){
					element.datepicker('hide');
				}
				if(event.keyCode == 72){
					element.datepicker({ dateFormat: 'dd-mm-yy'}).datepicker("setDate", new Date());
				}
			});
		},
		destroy: function(element){
			element.datepicker("destroy");
			element.removeClass("hasDatepicker");
			element.unbind("keydown");
			element.unbind("dblclick");
			if(element.data('mask')){
				element.data('mask').remove();
			}
		}
	}
}
