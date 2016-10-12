import-file
    h4 Шаг 1. Файл данных

    form(onchange='{ change }', onkeyup='{ change }')
        .col-md-3: .form-group
            label.control-label Файл импорта
            .input-group
                input.form-control(name='filename', value='{ parent.item.filename }', placeholder='Выберите файл',
                disabled='true')
                span.input-group-addon.btn-file.btn.btn-default(onchange='{ parent.changeFile }')
                    input(name='file', type='file', , accept='.csv,.xls,.xlsx')
                    i.fa.fa-fw.fa-folder-open
        .col-md-3: .form-group
            label.control-label Профиль загрузки
            select.form-control(name='profile', value='{ parent.item.idProfile }')
                option(value='')
                option(each='{ parent.item.profiles }', value='{ id }',
                selected='{ id == parent.item.idProfile }', no-reorder) { name }


    script(type='text/babel').
        var self = this

