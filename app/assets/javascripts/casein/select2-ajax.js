/*  
	Esta funcionalidade serve para carregar valores para o select2 por ajax;
	Como funciona:
		Inicialmente o elemento precisa ter um data-s2ajax=true para saber que o elemento vai ser um select2,
		lembrando que esse elemento sempre deve ser um input do tipo hidden.
		-> é necessário ter um data-url para saber onde a requisição será feita para carregar os valores.
		-> Quano o select for aberto, irá fazer o ajax para carregar os dados, e caso o select for aberto novamente, não será mais
		   feito o ajax, pois os dados do select para cada elemento fica salvo na variável dataSelect2Ajax.
		-> Caso tenha a necessidade de que cada vez que o select for aberto seja feito uma nova requisição, basta adicionar um data-not-cache=true.
		-> também é possível definir os parametros que serão passados na requisição ajax, basta colocar o data-params="{"key": "value"}". Veja que
		   o data-params deve ter um valor do tipo json
		-> Caso haja a necessidade de passar por parâmetro um valor de outro elemento de um formulário, basta passar o data-find-params="[{"key": 'param_name', "element": "#id_ou_qq_coisa"}]"
		   A key é o nome do parametro que será passado na requisição.
		   O element é o ID, class ou qualquer coisa de um determinado elemento que deseja obter o valor do mesmo para passar por parâmetro
*/
var dataSelect2Ajax = {};
var ApplySelect2Ajax = {
	setup: function(){
		$("[data-s2ajax=true]").not('.on-s2-ajax').each(function(index, el){
			var $el = $(el),
			url = $el.data('url'),
			char_min = $el.data('char-min') || 0,
			placeholder = $el.attr('placeholder') || 'Selecione...',
			not_cache = $el.data('not-cache') || false,
			allow_blank = $el.data('allow-blank') || false,
			blank_text = $el.data('blank-text') || placeholder,
			keys2 = $el.data('keys2') || false;
			if(!keys2){
				var time = new Date().getTime();
				keys2 = time;
				$el.data('keys2', time);
			}

			$el.select2({
				dataSource: [1,2],
				placeholder: placeholder,
				minimumInputLength: char_min,
				multiple: false,
				cache: true,
				quietMillis: 200,
				id: function(data){ return data.id; },
				query: function (query){
					var data = {results: []};
					

					function filter(){
						jQuery(document).off('.s2Ajax');
						if(allow_blank){
							data.results.push({id: '', name: blank_text });
						}
						$.each(dataSelect2Ajax[keys2], function(){
							if(query.term.length == 0 || this.name.toUpperCase().indexOf(query.term.toUpperCase()) >= 0 ){
								data.results.push({id: this.id, name: this.name, data: this.data });
							}
						});
			    		query.callback(data);
					}

					if(dataSelect2Ajax[keys2]){
						filter();
					}else{
						jQuery(document).on('ajaxStop.s2Ajax', function(){
							filter();
						});
					}
				},
				formatResult: ApplySelect2Ajax.formatResult,
				formatSelection: ApplySelect2Ajax.formatSelection,
				initSelection: function(elem, callback) {
					var $el = $(elem),
					id = $el.val(),
					name = $el.data('name');
					if(id){
						callback({id:id,  name: name});
					}
				}
			}).on('select2-opening', function() {
				if(not_cache){dataSelect2Ajax[keys2] = false};
				if(dataSelect2Ajax[keys2]){return true};
				$.get(url, ApplySelect2Ajax.optionForAjax($el) ).done(function( data ) {
					dataSelect2Ajax[keys2] = data.items;
				});
			});
		});
		$("[data-s2ajax=true]").addClass('on-s2-ajax');
	},

	optionForAjax: function(el){
		var options = {},
		data_find = el.data('find-params') || [];
		if(el.data('params')){ options = el.data('params') }

		$.each(data_find, function(index, val) {
			options[val['key']] = $(val['element']).val();
		});

		return options;
	},


	formatSelection: function(item) {
		if(item.data){ApplySelect2Ajax.applyDataOptions(this.element, item.data);}
		return item.name
	},

	formatResult: function(item) {
		return '<span class="select2-chosen">'+ item.name +'</span>'
	},
	applyDataOptions: function(el, data){
		var $el = $(el);
		$.each(data, function(index, value) {
			$el.data(index, value);
		}); 
	}
}