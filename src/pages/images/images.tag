| import 'components/filemanager.tag'

images
    loader(if='{ loader }')
    filemanager(value='{ value }', reload='{ reload }')

    script(type='text/babel').
        var self = this,
            route = riot.route.create()

        self.loader = false

        self.reload = data => {
            self.loader = true
            API.request({
                object: 'ImageFolder',
                method: 'Fetch',
                data: data || {},
                success(response) {
                    self.value = response.items
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

        route('images', () => {
            self.reload()
        })

        self.on('mount', () => {
            riot.route.exec()
        })