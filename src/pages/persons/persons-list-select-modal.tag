persons-list-select-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title Контакты
        #{'yield'}(to="body")
            catalog(object='Contact', cols='{ parent.cols }', search='true', reload='false', disable-col-select='1')
                #{'yield'}(to='body')
                    datatable-cell(name='id') { row.id }
                    datatable-cell(name='displayName') { row.displayName }
                    datatable-cell(name='username') { row.username }
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') Выбрать

    script(type='text/babel').
        var self = this

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'displayName', value: 'Ф.И.О'},
            {name: 'username', value: 'Логин'}
        ]

