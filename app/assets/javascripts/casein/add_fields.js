function change_props_fields($elem){
	var time = new Date().getTime();
	var regexp = new RegExp($elem.data('id'), 'g');
	var find  = $elem.data('find') || '#content-filtros';
	var local = $elem.data('local') || 'append';
	var url   = $elem.data('url') || false;
	var data_url = $elem.data('url-data') || {};
	var url_method = $elem.data('url-method') || 'GET';
	var before_execute = $elem.data('before-execute') || [];
	var after_execute = $elem.data('after-execute') || [];
	var el = $(find);
	data_url['time'] = time;
	$.each(before_execute, function(index, val) {
		eval(val);
	});
	if(local == 'append'){
		el.append($elem.data('fields').replace(regexp, time));
	}else if(local == 'before'){
		el.before($elem.data('fields').replace(regexp, time));
	}else if(local == 'after'){
		el.after($elem.data('fields').replace(regexp, time));
	}else if(local == 'prepend'){
		el.prepend($elem.data('fields').replace(regexp, time));
	}else if(local == 'html'){
		el.html($elem.data('fields').replace(regexp, time));
	}
	$.each(after_execute, function(index, val) {
		eval(val);
	});
	// TwsystemSelect2.setup();
	// Checkboxes.setup();
	// TwMask.setup();
	// Trumbowyg.setup();
	// Focus.formGroup(el.children(':last'));
	if(url){
		$.ajax({
			url: url,
			type: url_method,
			dataType: 'script',
			data: data_url
		});
	}
	bind_remove_fields();
};
function bind_add_fields(){
	$('.add_fields-v2').not('.on-add-fields').on('click', function(){
		change_props_fields($(this))
	});
	$('.add_fields-v2').addClass('on-add-fields');
};
function bind_remove_fields(){
	$('.remove_field').not('.on').on('click', function(event) {
		var $el = $(this),
		find = $el.data('find'),
		hide_el = $el.data('hide') || false,
		no_blank = $el.data('noblank') || false,
		before_execute = $el.data('before-execute') || [],
		after_execute = $el.data('after-execute') || [],
		html_message = $el.parents(find+":first").find('.message').html();

		if(no_blank && $el.parents(find+":first").parent().find(find).length == 1 ){
			return true;
		}else{
			$.each(before_execute, function(index, val) {
				eval(val);
			});
			$el.parents(find+":first").before(html_message);
			setTimeout(function() {
				// Esse timeout é necessário para que seja executado outros .on(click) no elemento
				if(hide_el) {
					$el.parents(find+":first").hide();
					$el.parents(find+":first").find('input[name*="_destroy"]').val('1');
				} else {
					$el.parents(find+":first").remove().trigger('remove');
				}
			}, 10);
			$.each(after_execute, function(index, val) {
				eval(val);
			});
		}
	});
	$('.remove_field').addClass('on');
}
function remove_field(that) {
	$(that).parents('tr:first').remove();
	$('[id^="consulta_filtros_attributes"][id$="id"]').remove();
};
