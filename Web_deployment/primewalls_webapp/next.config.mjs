/** @type {import('next').NextConfig} */
const nextConfig = {
    images: {
        domains: ['picsum.photos'],
    },
    icons: {
        icon: "/favicon.ico", // path in /public
    },
    devIndicators: false,
};

export default nextConfig;
