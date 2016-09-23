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
                button.btn.btn-default(type='button', title='Новая папка', onclick='{ newFolder }')
                    i.fa.fa-plus
            .input-group
                .input-group-btn
                    button.btn.btn-default(type='button', title='Домой', onclick='{ goToHome }')
                        i.fa.fa-home
                input.form-control(type='text', value='{ path }', readonly)
    .filemanager__body(onclick='{ setUnselectAllFiles }', ontouchmove='{ bodyScroll }')
        loader(if='{ loader }')
        .filemanager__file(each='{ value }', onclick='{ fileClick }', ontouchstart='{ fileTouchStart }',
        ontouchend='{ fileTouchEnd }', class='{ filemanager__file_selected: __selected__ }')
            .filemanager__file-icon(if='{ isDir }')
                i.fa.fa-folder-o.fa-4x
            .filemanager__file-icon(if='{ !isDir }', style="background-image: url({ urlPreview })")
            .filemanager__filename(title='{ name }') { name }

    .filemanager__status-panel
        span Выделено: { getSelectedFilesCount() }

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
            position: relative;
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
            outline: 1px solid #D6FFFF;
            background-color: #F3FFFF;
            cursor: default;
        }

        .filemanager__file_selected,
        .filemanager__file_selected:hover {
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
            padding: 2px;
            box-sizing: border-box;
        }

    script(type='text/babel').
        let self = this
        self.value = []
        self.path = '/'
        self.historyBackward = []
        self.historyForward = []
        self.selectedCount = 0

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

        let lastSelectedRowIndex = 0
        self.fileClick = e => {
            e.stopPropagation()

            let currentSelectedRowIndex = self.value.indexOf(e.item)
            var currentClick = Date.now()
            var clickLength = currentClick - (e.item.__lastClick__ || 0)

            if (clickLength < 300 && clickLength > 0 && !e.ctrlKey && !e.metaKey && !e.shiftKey) {
                currentClick = 0
                self.openFolder(e)
            }

            if (!e.shiftKey) {
                if (!e.ctrlKey && !e.metaKey)
                    self.selectOneFile(e)
                else
                    self.setFileSelected(e.item, !e.item.__selected__)
            } else {
                if (currentSelectedRowIndex >= lastSelectedRowIndex)
                    self.selectRangeFiles(lastSelectedRowIndex, currentSelectedRowIndex)
                else
                    self.selectRangeFiles(currentSelectedRowIndex, lastSelectedRowIndex)
            }

            if (!e.shiftKey)
                lastSelectedRowIndex = currentSelectedRowIndex

            e.item.__lastClick__ = currentClick
        }

        var bodyScroll = false
        self.bodyScroll = e => {
            bodyScroll = true
            return true
        }

        self.fileTouchStart = e => {
            var item = e.item
            item.__tapLong__ = false
            bodyScroll = false
            item.__lastTapStart__ = Date.now()

            item.__tapStartTimer__ = setTimeout(() => {
                if (!bodyScroll) {
                    self.setFileSelected(item, !item.__selected__)
                    item.__tapLong__ = true
                    self.update()
                }
            }, 400)

            return true
        }

        self.fileTouchEnd = e => {
            var item = e.item
            var currentTap = Date.now()
            var tapLength = currentTap - (item.__lastTapEnd__ || 0)

            if (item.__tapStartTimer__)
                clearTimeout(item.__tapStartTimer__)

            if (!bodyScroll && !item.__tapLong__) {
                self.selectOneFile(e)
            }

            if (tapLength < 500 && tapLength > 0) {
                currentTap = 0
                self.openFolder(e)
            }

            item.__lastTapEnd__ = currentTap
            return true
        }

        self.higherFolder = () => {
            if (["", "/"].indexOf(self.path) > - 1) return
            let path = self.path.split('/')
            if (path.length > 1 && path[0] === path[1])
                path.splice(0, 1)
            path.pop()
            self.historyBackward.push(self.path)
            self.historyForward = []
            self.path = path.join('/') === '' ? '/' : path.join('/')
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

        self.setFileSelected = (file, value) => {
            file.__selected__ = value
        }

        self.selectOneFile = e => {
            self.value.forEach(item => {
                self.setFileSelected(item, false)
            })
            self.setFileSelected(e.item, true)
        }

        self.selectRangeFiles = function (start, end) {
            for (var i = 0; i < self.value.length; i++) {
                if (i >= start && i <= end)
                    self.setFileSelected(self.value[i], true)
                else
                    self.setFileSelected(self.value[i], false)
            }
            self.update()
        }

        self.getSelectedFiles = () => {
            return self.value.filter(item => {
                return item.__selected__ == true
            })
        }

        self.getUnselectedFiles = () => {
            return self.value.filter(item => {
                return !item.__selected__
            })
        }

        self.getSelectedFilesCount = () => {
            return self.getSelectedFiles().length
        }

        self.setUnselectAllFiles = () => {
            return self.value.map(item => {
                item.__selected__ = false
            })
        }

        self.newFolder = () => {
            modals.create('filemanager-rename-modal', {
                type: 'modal-primary',
                title: 'Новая папка',
                submit() {
                    let _this = this
                    let params = {
                        cmd: 'create',
                        name: _this.item.name,
                        path: self.path
                    }

                    API.request({
                        object: 'ImageFolder',
                        method: 'Save',
                        data: params,
                        success(response) {
                            _this.modalHide()
                            self.reload()
                        }
                    })
                }
            })
        }

        self.reload = data => {
            self.loader = true
            API.request({
                object: 'ImageFolder',
                method: 'Fetch',
                data: {path: self.path + '/'},
                success(response) {
                    let value = response.items
                    if (value instanceof Array) {
                        let folders = value.filter(i => i.isDir).sort((a, b) => a.name > b.name)
                        let files = value.filter(i => !i.isDir).sort((a, b) => a.name > b.name)
                        self.value = opts.value = self.root.value = [...folders, ...files]
                    } else {
                        self.value = opts.value = self.root.value = []
                    }
                },
                error() {
                    self.value = []
                },
                complete() {
                    self.loader = false
                    self.update()
                }
            })
        }

filemanager-rename-modal
    bs-modal
        #{'yield'}(to="title")
            .h4.modal-title { parent.opts.title }
        #{'yield'}(to="body")
            form(onchange='{ change }', onkeyup='{ change }')
                .form-group(class='{ has-error: error.name }')
                    label.control-label Имя
                    input.form-control(name='name', type='text')
                    .help-block { error.name }
        #{'yield'}(to='footer')
            button(onclick='{ modalHide }', type='button', class='btn btn-default btn-embossed') Закрыть
            button(onclick='{ parent.opts.submit.bind(this) }', type='button', class='btn btn-primary btn-embossed') Сохранить

    script(type='text/babel').
        var self = this

        self.on('mount', () => {
            let modal = self.tags['bs-modal']

            modal.item = opts.item || {}
            modal.mixin('validation')
            modal.mixin('change')

            modal.rules = {
                name: 'empty'
            }

            modal.afterChange = e => {
                modal.error = modal.validation.validate(modal.item, modal.rules, e.target.name)
            }
        })
