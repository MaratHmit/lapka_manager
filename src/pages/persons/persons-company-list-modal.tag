persons-company-list-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title Контакты
        #{'yield'}(to="body")
            ul.nav.nav-tabs.m-b-2
                li(each='{ tabs }', class='{ active: name == tab }')
                    a(href='#', onclick='{ tabClick }')
                        span { title }

            catalog(if='{ tab == "contacts" }', name='contacts', object='Contact', cols='{ contactCols }',
            search='true', reload='false', disable-col-select='1')
                datatable-cell(name='id') { row.id }
                datatable-cell(name='displayName') { row.displayName }
                datatable-cell(name='username') { row.username }

            catalog(if='{ tab == "companies" }', name='companies', object='Company', cols='{ companyCols }',
            search='true', reload='false', disable-col-select='1')
                datatable-cell(name='id') { row.id }
                datatable-cell(name='displayName') { row.name }

        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit }', type='button', class='btn btn-primary btn-embossed') Выбрать

    script(type='text/babel').
        var self = this

        self.on('mount', () => {
            let modal = self.tags['bs-modal']

            modal.tab = 'contacts'

            modal.tabClick = e => {
                modal.tab = e.item.name
            }

            modal.tabs = [
                {name: 'contacts', title: 'Контакты'},
                {name: 'companies', title: 'Компании'},
            ]

            modal.contactCols = [
                {name: 'id', value: '#'},
                {name: 'displayName', value: 'Ф.И.О'},
                {name: 'username', value: 'Логин'}
            ]

            modal.companyCols = [
                {name: 'id', value: '#'},
                {name: 'name', value: 'Наименование'},
            ]

        })



