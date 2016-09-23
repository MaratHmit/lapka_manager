| import 'components/loader.tag'

filemanager
    .filemanager__control-panel
        .form-inline
            .btn-group
                button.btn.btn-default(type='button', title='Назад', class='{ disabled: !historyBackward.length }',
                onclick='{ backward }')
                    i.fa.fa-arrow-left
                button.btn.btn-default(type='button', title='Вперед', class='{ disabled: !historyForward.length }',
                onclick='{ forward }')
                    i.fa.fa-arrow-right
                button.btn.btn-default(type='button', title='Вверх', class!='{ disabled: ["", "/"].indexOf(path) > - 1 }',
                onclick='{ higherFolder }')
                    i.fa.fa-arrow-up
                button.btn.btn-default(type='button', title='Обновить', onclick='{ reload }')
                    i.fa.fa-refresh
            .btn-group
                button.btn.btn-default(type='button', title='Загрузка')
                    i.fa.fa-upload
                button.btn.btn-default(type='button', title='Новая папка')
                    i.fa.fa-plus
            .input-group
                .input-group-btn
                    button.btn.btn-default(type='button', title='Домой', onclick='{ goToHome }')
                        i.fa.fa-home
                input.form-control(type='text', value='{ path }')
    .filemanager__body
        .filemanager__file(each='{ value }')
            .filemanager__file-icon(if='{ isDir }', ondblclick='{ openFolder }')
                i.fa.fa-folder-o.fa-4x
            .filemanager__file-icon(if='{ !isDir }', style="background-image: url({ urlPreview })")
                //img.img-responsive(src='{ urlPreview }')
            .filemanager__filename(title='{ name }') { name }

    .filemanager__status-panel
        span Выделено: 0

    style(scoped).
        .filemanager__control-panel {
            padding: 4px;
            border: 1px solid #ccc;
            border-radius: 4px 4px 0 0;
            background-color: #eee;
        }

        .filemanager__body {
            padding: 4px;
            border-left: 1px solid #ccc;
            border-right: 1px solid #ccc;
            display: block;
            min-height: calc(100vh - 150px);
            overflow-y: auto;
            height: 300px;
        }

        .filemanager__status-panel {
            padding: 4px;
            border: 1px solid #ccc;
            border-radius: 0 0 4px 4px;
            background-color: #eee;
        }

        .filemanager__file {
            display: inline-block;
            position: relative;
            width: 100px;
            height: 100px;
            margin: 4px;
            box-sizing: content-box;
        }

        .filemanager__file:hover {
            outline: 1px solid #bce8f1;
            background-color: #d9edf7;
            cursor: default;
        }

        .filemanager__file-icon {
            position: absolute;
            bottom: 32px;
            left: 0;
            right: 0;
            top: 0;
            text-align: center;
            line-height: 8;
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
        }

        .filemanager__filename {
            position: absolute;
            height: 35px;
            font-size: 11px;
            text-align: center;
            bottom: 0;
            left: 0;
            right: 0;
            overflow: hidden;
            word-wrap: break-word;
        }

    script(type='text/babel').
        let self = this
        self.value = []
        self.path = '/'
        self.historyBackward = []
        self.historyForward = []

        self.backward = () => {
            if (!self.historyBackward.length) return
            let path = self.historyBackward.pop()
            self.historyForward.push(self.path)
            self.path = path
            self.reload()
        }

        self.forward = () => {
            if (!self.historyForward.length) return
            let path = self.historyForward.pop()
            self.historyBackward.push(self.path)
            self.path = path
            self.reload()
        }

        self.higherFolder = () => {
            if (["", "/"].indexOf(self.path) > - 1) return
            let path = self.path.split('/')
            if (path.length > 1 && path[0] === path[1])
                path.splice(0, 1)
            path.pop()
            self.historyBackward.push(self.path)
            self.historyForward = []
            self.path = path.join('/')
            self.reload()
        }

        self.openFolder = e => {
            let path = self.path.split('/')
            if (path.length > 1 && path[0] === path[1])
                path.splice(0, 1)
            path.push(e.item.name)
            self.historyBackward.push(self.path)
            self.historyForward = []
            self.path = path.join('/')
            self.reload()
        }

        self.goToHome = () => {
            self.historyBackward.push(self.path)
            self.historyForward = []
            self.path = '/'
            self.reload()
        }

        self.reload = () => {
            if (typeof opts.reload === 'function')
                opts.reload({ path: self.path })
        }

        self.on('update', () => {
            let value = opts.value

            if (value instanceof Array) {
                let folders = value.filter(i => i.isDir).sort((a, b) => a.name > b.name)
                let files = value.filter(i => !i.isDir).sort((a, b) => a.name > b.name)
                self.value = opts.value = self.root.value = [...folders, ...files]
            } else {
                self.value = opts.value = self.root.value = []
            }
        })


