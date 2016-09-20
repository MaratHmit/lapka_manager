

letter
    h4 Шаблоны писем

    catalog(object='LetterTemplate', cols='{ cols }', reload='true', handlers='{ handlers }',
    add='{ permission(add, "mails", "0100") }',
    remove='{ permission(remove, "mails", "0001") }',
    dblclick='{ permission(letterOpen, "mails", "1000") }')
        #{'yield'}(to='body')
            datatable-cell(name='id') { row.id }
            datatable-cell(name='title') { row.title }
            datatable-cell(name='mailtype') { row.mailtype }
            datatable-cell(name='subject') { row.subject }

    script(type='text/babel').
        var self = this

        self.mixin('permissions')
        self.mixin('remove')

        self.collection = 'LetterTemplate'

        self.cols = [
            {name: 'id', value: '#'},
            {name: 'title', value: 'Наименование'},
            {name: 'itempost', value: 'Код'},
            {name: 'subject', value: 'Тема'}
        ]

        self.add = () => riot.route('settings/letter/new')

        self.letterOpen = e => riot.route(`settings/letter/${e.item.row.id}`)

        observable.on('letters-reload', () => {
            self.tags.catalog.reload()
        })
