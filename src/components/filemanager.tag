| import 'components/loader.tag'

filemanager
    .filemanager__control-panel
        .form-inline
            .btn-group
                button.btn.btn-default(type='button', title='Назад')
                    i.fa.fa-arrow-left
                button.btn.btn-default(type='button', title='Вперед')
                    i.fa.fa-arrow-right
                button.btn.btn-default(type='button', title='Вверх')
                    i.fa.fa-arrow-up
                button.btn.btn-default(type='button', title='Обновить')
                    i.fa.fa-refresh
            button.btn.btn-default(type='button', title='Загрузка')
                i.fa.fa-upload
            input.form-control(type='text')
    .filemanager__body
        .filemanager__file(each='{ value }')
            .filemanager__file-icon(if='{ isDir }')
                i.fa.fa-folder-o.fa-4x
            .filemanager__filename(title='{ name }') { name }

    .filemanager__status-panel
        span Выделено: 0

    style(scoped).
        .filemanager__control-panel {
            padding: 4px;
            border: 1px solid #ccc;
            border-radius: 4px 4px 0 0;
            background-color: #e5e5e5;
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
            background-color: #e5e5e5;
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
        }

        .filemanager__file-icon {
            position: absolute;
            bottom: 32px;
            left: 0;
            right: 0;
            top: 0;
            text-align: center;
            line-height: 8;
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

        self.on('update', () => {
            self.value = opts.value
        })


