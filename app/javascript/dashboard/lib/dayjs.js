import dayjs from 'dayjs'
import relativeTime from 'dayjs/plugin/relativeTime'
import duration from 'dayjs/plugin/duration'
import 'dayjs/locale/ru'
import 'dayjs/locale/uk'

dayjs.extend(relativeTime)
dayjs.extend(duration)

export default dayjs
