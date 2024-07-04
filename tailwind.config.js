/** @type {import('tailwindcss').Config} */

export default {

    content: [
        "./index.html",
        "./src/**/*.{js,ts,jsx,tsx}",
    ],
    theme: {
        extend: {
            width: {
                'Box': '50rem',
            }

        },
        fontFamily: {
            'mono': 'JetBrains Mono'
        },
        plugins: [
            require('tailwind-scrollbar'),
        ]
    }
}

