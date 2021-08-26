// CASEIN CUSTOM
// Use this file for your project-specific Casein JavaScript

//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery-fileupload
//= require turbolinks
// require tinymce-jquery
//= require bootstrap-switch
//= require bootstrap/tab
//= require bootstrap/modal
//= require 'icheck'
//= require select2
//= require select2_locale_pt-BR
//= require bootstrap-custom/bootstrap-spinner
//= require inputmask
//= require jquery.inputmask
//= require handle_cep
//= require inputmask.extensions
//= require inputmask.date.extensions
//= require inputmask.phone.extensions
//= require inputmask.numeric.extensions
//= require inputmask.regex.extensions
//= require nprogress
//= require nprogress-turbolinks
//= require nprogress-ajax
//= require mascara/addon_datepicker_hora
//= require mascara/mascara
//= require mascara/tw_config
//= require mascara/jquery.mask.min
//= require jquery.minicolors
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require casein/select2-ajax
//= require casein/gauge/chart.min
//= require casein/gauge/gauge.min
//= require ckeditor/init
//= require lightbox
//= require casein/datatables-neutralize
//= require casein/add_fields

jQuery(document).on('page:load', aplicationReady);
jQuery(document).ready(function($) {aplicationReady();});

function aplicationReady(){
  // $('.ckeditor').each(function() {
  //   CKEDITOR.replace($(this).attr('id'));
  // });

  handle_the_cep();
  turbolinkCkeditor();

  bind_add_fields();
  
  
  TwMask.setup();

  ApplySelect2Ajax.setup();
  
  aplicarMascaras();

  // $('.datepicker').datepicker({
  //   format: "dd/mm/yyyy"
  // });

  // ativar tooltip
  $('[data-toggle="tooltip"]').tooltip();

  //funcao para fechar os alerts ao clicar no X
  $(".close").click(function(){
    $(this).parent().addClass("closed");
  });

  createJSDatatablesAjax('#casein-clientes-table', [{"data": "id"},{"data": "nome"},{"data": "tipo"},{"data": "email_contato"},{"data": "view"}]);
  createJSDatatablesAjax('#casein-pocos-table', [{"data": "id"},{"data": "nome"},{"data": "linha_endereco"},{"data": "apelido_endereco"},{"data": "cidade"},{"data": "produtivo"},{"data": "perfuracao_leao"},{"data": "view"}]);
  createJSDatatablesAjax('#casein-vazoes-agua-table', [{"data": "id"},{"data": "nome"},{"data": "linha_endereco"},{"data": "apelido_endereco"},{"data": "vazao_teste"},{"data": "vazao_dinamico"},{"data": "nivel_estatico"},{"data": "view"}]);
  createJSDatatablesAjax('#casein-instalacoes-table', [{"data": "id"},{"data": "nome"},{"data": "linha_endereco"},{"data": "apelido_endereco"},{"data": "bomba"},{"data": "view"}]);
  createJSDatatablesAjax('#casein-manutencaos-table', [{"data": "id"},{"data": "nome"},{"data": "linha_endereco"},{"data": "apelido_endereco"},{"data": "tipo"},{"data": "ultimo_servico"},{"data": "data"},{"data": "view"}]);
  createJSDatatablesAjax('#casein-aprofundamentos-table', [{"data": "id"},{"data": "nome"},{"data": "linha_endereco"},{"data": "apelido_endereco"},{"data": "cidade"},{"data": "data_inicio"},{"data": "data_fim"},{"data": "view"}]);

  $('.datatable-dashboard').DataTable({
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // processing: true,
    // serverSide: true,
    "lengthChange": false,
    "searching": false,
    "pageLength": 5,
    "order": [1],

    "language": {
        "sProcessing":    "Processando...",
        "sLengthMenu":    "Mostrar _MENU_ registros",
        "sZeroRecords":   "Não foram localizados resultados",
        "sEmptyTable":    "Nenhum dado está disponível nesta tabela",
        "sInfo":          "_TOTAL_ registros",
        "sInfoEmpty":     "Mostrando registros de 0 a 0 de um total de 0 registros",
        "sInfoFiltered":  "(filtrado de um total de _MAX_ registros)",
        "sInfoPostFix":   "",
        "sSearch":        "Buscar:",
        "sUrl":           "",
        "sInfoThousands":  ",",
        "sLoadingRecords": "Carregando...",
        "oPaginate": {
            "sFirst":    "Primeiro",
            "sLast":    "Último",
            "sNext":    "Próximo",
            "sPrevious": "Anterior"
        },
        "oAria": {
            "sSortAscending":  ": Ativar para ordenar a coluna de maneira crescente",
            "sSortDescending": ": Ativar para ordenar a coluna de maneira decrescente"
        }
    }
  });
  
  var datatableNeutralize = $('.datatable').DataTable({
    // autoWidth: false,
    // pagingType: 'full_numbers',
    // processing: true,
    // serverSide: true,
    "pageLength": 25,
    "order": [],

    "language": {
        "sProcessing":    "Processando...",
        "sLengthMenu":    "Mostrar _MENU_ registros",
        "sZeroRecords":   "Não foram localizados resultados",
        "sEmptyTable":    "Nenhum dado está disponível nesta tabela",
        "sInfo":          "Mostrando registros de _START_ a _END_ de um total de _TOTAL_ registros",
        "sInfoEmpty":     "Mostrando registros de 0 a 0 de um total de 0 registros",
        "sInfoFiltered":  "(filtrado de um total de _MAX_ registros)",
        "sInfoPostFix":   "",
        "sSearch":        "Buscar:",
        "sUrl":           "",
        "sInfoThousands":  ",",
        "sLoadingRecords": "Carregando...",
        "oPaginate": {
            "sFirst":    "Primeiro",
            "sLast":    "Último",
            "sNext":    "Próximo",
            "sPrevious": "Anterior"
        },
        "oAria": {
            "sSortAscending":  ": Ativar para ordenar a coluna de maneira crescente",
            "sSortDescending": ": Ativar para ordenar a coluna de maneira decrescente"
        }
    }
  });

  // Remove accented character from search input as well
  $('.dataTables_wrapper .dataTables_filter input[type="search"]').keyup( function () {
    datatableNeutralize
      .search(
        jQuery.fn.DataTable.ext.type.search.string( this.value )
      )
      .draw()
  } );

  $(".select_padrao").select2({
    placeholder: "Selecione.."
  });

  montarSelect2(".select_maquina", "adicionar-maquina", "/ajax/maquinas/adicionar");
  montarSelect2(".select_bitola", "adicionar-bitola", "/ajax/bitolas/adicionar");
  form_change_url();
}

function turbolinkCkeditor() {
  $(window).on("page:before-unload", function(e) {
    if (CKEDITOR && CKEDITOR.instances) {
      for(name in CKEDITOR.instances) {
        if (CKEDITOR.instances.hasOwnProperty(name)) {
          CKEDITOR.instances[name].destroy(true);
        }
      }
    }
  });
}

function add_fields(link, association, content, target) {
  // remove todos os select2 da pagina atual
  $(".select_padrao").select2('destroy'); 
  $(".select_maquina").select2('destroy'); 
  $(".select_bitola").select2('destroy'); 

  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");

  $("#" + target).append(content.replace(regexp, new_id));
  // $("#" + association).find('input:visible:first').focus();
  
  TwMask.setup();

  ApplySelect2Ajax.setup();
  
  aplicarMascaras();

  // adiciona os select2 no form atual
  $(".select_padrao").select2({
    placeholder: "Selecione.."
  });

  montarSelect2(".select_maquina", "adicionar-maquina", "/ajax/maquinas/adicionar");
  montarSelect2(".select_bitola", "adicionar-bitola", "/ajax/bitolas/adicionar");
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function createPie(id) {
  var ctx = document.getElementById(id).getContext("2d");
  var data = [
      {
          value: 300,
          color:"#F7464A",
          highlight: "#FF5A5E",
          label: "Red"
      },
      {
          value: 50,
          color: "#46BFBD",
          highlight: "#5AD3D1",
          label: "Green"
      },
      {
          value: 100,
          color: "#FDB45C",
          highlight: "#FFC870",
          label: "Yellow"
      }
  ];

  var myPieChart = new Chart(ctx).Pie(data);
}

function createGauge(value, maxValue, id) {
  var opts = {
    lines: 12, // The number of lines to draw
    angle: 0, // The length of each line
    lineWidth: 0.4, // The line thickness
    pointer: {
      length: 0.75, // The radius of the inner circle
      strokeWidth: 0.042, // The rotation offset
      color: '#1D212A' // Fill color
    },
    limitMax: 'false', // If true, the pointer will not go past the end of the gauge
    colorStart: '#1ABC9C', // Colors
    colorStop: '#1ABC9C', // just experiment with them
    strokeColor: '#F0F3F3', // to see which ones work best for you
    generateGradient: true
  };
  var target = document.getElementById(id); // your canvas element
  var gauge = new Gauge(target).setOptions(opts); // create sexy gauge!
  gauge.maxValue = maxValue; // set max gauge value
  gauge.animationSpeed = 32; // set animation speed (32 is default value)
  gauge.set(value); // set actual value
  gauge.setTextField(document.getElementById("gauge-text"));
}

function aplicarMascaras() {
  // mascaras
  $(".masc-telefone").inputmask("(99) 9999-99999");
  $(".masc-cpf").inputmask("999.999.999-99");
  $(".masc-number").inputmask("9999", {"placeholder": ""});
  $(".masc-coordenada").inputmask("9999999999");
  $(".masc-coordenada-zona").inputmask("***********");
  $(".masc-decimal").inputmask("decimal", { radixPoint: ",", digits: 2, autoGroup: true, groupSeparator: "", placeholder: "0.00", digitsOptional: false });
  $(".masc").inputmask();
}

function montarSelect2(classe, idLink, url) {
  var index = $(classe).data("index");

  $(classe).select2({
    formatNoMatches: function(item) {
      return "<a href='#' id='"+idLink+"' data-item='"+item+"' data-index='"+index+"' class='btn btn-primary btn-sm pull-right'>Cadastrar Novo</a><script type='text/javascript'>$('#"+idLink+"').click(function(){$.ajax({url: '"+url+"', data: { item: $(this).data('item'), index: '"+index+"' } });});</script>"
    }
  });
}

function icheck(){
  if($(".icheck-me").length > 0){
    $(".icheck-me").each(function(){
      var $el = $(this);
      var skin = ($el.attr('data-skin') !== undefined) ? "_" + $el.attr('data-skin') : "",
      color = ($el.attr('data-color') !== undefined) ? "-" + $el.attr('data-color') : "";
      var opt = {
        checkboxClass: 'icheckbox' + skin + color,
        radioClass: 'iradio' + skin + color,
      }
      $el.iCheck(opt);
    });
  }
}

$(function(){
  icheck();
})

function form_change_url () {
  $('.form_change_url').not('.on').on('click', function(event) {
    var find_form = $(this).data('form') || $(this).parents('form');
    var form = $(find_form);
    var method = $(this).data('method');
    var old_url = form.attr('action');
    var new_url = $(this).data('url');
    var new_target = $(this).data('target');
    var old_target = form.attr('target');
    form.attr('action', new_url);
    form.attr('target', new_target);
    if(method) form.append('<input id="new_method" name="_method" type="hidden" value="'+method+'">');
    if(! old_target){ old_target = '_self' }
    form.submit();
    form.attr('action', old_url);
    form.attr('target', old_target);
    form.find('#new_method').remove();
    return false;
  });
  $('.form_change_url').addClass('on');
}

function printDiv(divName) {
  var printContents = document.getElementById(divName).innerHTML;
  var originalContents = document.body.innerHTML;

  document.body.innerHTML = printContents;

  window.print();

  document.body.innerHTML = originalContents;
}

function createJSDatatablesAjax(id, columns) {
  //ajax-datatables
  $(id).dataTable({
    "processing": false,
    "serverSide": true,
    "ajax": $(id).data('source'),
    "pagingType": "full_numbers",
    "pageLength": 25,
    "columns": columns,
    "language": {
      "sProcessing":    "Processando...",
      "sLengthMenu":    "Mostrar _MENU_ registros",
      "sZeroRecords":   "Não foram localizados resultados",
      "sEmptyTable":    "Nenhum dado está disponível nesta tabela",
      "sInfo":          "_TOTAL_ registros",
      "sInfoEmpty":     "Mostrando registros de 0 a 0 de um total de 0 registros",
      "sInfoFiltered":  "(filtrado de um total de _MAX_ registros)",
      "sInfoPostFix":   "",
      "sSearch":        "Buscar:",
      "sUrl":           "",
      "sInfoThousands":  ",",
      "sLoadingRecords": "Carregando...",
      "oPaginate": {
          "sFirst":    "Primeiro",
          "sLast":    "Último",
          "sNext":    "Próximo",
          "sPrevious": "Anterior"
      },
      "oAria": {
          "sSortAscending":  ": Ativar para ordenar a coluna de maneira crescente",
          "sSortDescending": ": Ativar para ordenar a coluna de maneira decrescente"
      }
    }
    // pagingType is optional, if you want full pagination controls.
    // Check dataTables documentation to learn more about
    // available options.
  });
}