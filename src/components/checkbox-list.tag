checkbox-list
    .checkbox(each='{ items }')
        label
            input(id='{ id }', type='checkbox', value='{ isChecked }', onclick='{ click }')
        | { name }

    script(type='text/babel').
        var self = this

        self.click = e => {
            let id = e.target.id
            let isChecked = e.target.checked
            self.items.forEach(item => {
                if (item.id == id)
                    item.isChecked = isChecked
            })

            var event = document.createEvent('Event')
            event.initEvent('change', true, true)
            self.root.dispatchEvent(event)
        }

        self.on('update', () => {
            self.items = opts.items
        })

