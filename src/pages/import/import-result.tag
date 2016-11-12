import-result
    | Импорт завершен
    .row
        .col-md-3: .form-group
            button.btn.btn-danger(onclick='{ parent.newImport }', type='button') Новый импорт
            button.btn.btn-primary(onclick='{ parent.catalog }', type='button') Справочник товаров
