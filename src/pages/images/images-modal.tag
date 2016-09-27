images-modal
    bs-modal
        #{'yield'}(to='title')
            .h4.modal-title Картинки
        #{'yield'}(to='body')
            filemanager
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') Сохранить

    script(type='text/babel').
        let self = this

        self.on('mount', () => {
            let modal = self.tags['bs-modal']
            modal.tags.filemanager.reload()
        })