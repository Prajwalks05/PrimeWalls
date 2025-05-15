// app/layout.js
import './globals.css'
import 'aos/dist/aos.css'

export const metadata = {
  title: 'App Showcase',
  description: 'A beautiful app showcase page',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}
