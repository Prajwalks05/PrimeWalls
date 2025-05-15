"use client"

import Image from "next/image"
import Link from "next/link"

import { Star, Wallpaper, Download, Smartphone } from "lucide-react"
import { Button } from "@/components/ui/button"

export default function AboutPage() {
    return (
        <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white">
            {/* Header */}
            <header className="sticky top-0 z-10 backdrop-blur-lg bg-white/80 border-b border-gray-100">
                <div className="container mx-auto px-4 py-4 flex items-center justify-between">
                    <div className="flex items-center gap-2">
                        <div className="flex items-center gap-2">
                            <div className="h-10 w-10 rounded-xl overflow-hidden bg-white">
                                <Image
                                    src="/logo.png"
                                    alt="App Logo"
                                    width={200}
                                    height={200}
                                    className="object-cover"
                                />
                            </div>
                        </div>
                        <span className="font-medium text-lg">AppStore</span>
                    </div>
                    <nav>
                        <ul className="flex gap-6">
                            <li>
                                <Link href="/" className="font-medium text-gray-600 hover:text-gray-900">
                                    Home
                                </Link>
                            </li>
                        </ul>

                    </nav>
                </div>
            </header>

            {/* About Section */}
            <section className="container mx-auto px-4 py-20">
                <div className="max-w-3xl mx-auto text-center">
                    <h1 className="text-4xl font-bold mb-4">About Our Wallpaper App</h1>
                    <p className="text-lg text-gray-600 mb-8">
                        Our wallpaper app is designed to bring your home screen to life with stunning, high-resolution backgrounds.
                        Whether you love minimal designs, nature, abstract art, or dark mode wallpapers — we have something for every style.
                    </p>
                    <div className="flex justify-center gap-4 flex-wrap mb-12">
                        <div className="flex items-center gap-2 text-gray-700">
                            <Wallpaper className="h-6 w-6 text-purple-500" />
                            <span>HD & 4K Wallpapers</span>
                        </div>
                        <div className="flex items-center gap-2 text-gray-700">
                            <Download className="h-6 w-6 text-blue-500" />
                            <span>Easy to set wallpaper</span>
                        </div>
                        <div className="flex items-center gap-2 text-gray-700">
                            <Smartphone className="h-6 w-6 text-green-500" />
                            <span>Fits Any Device</span>
                        </div>
                        <div className="flex items-center gap-2 text-gray-700">
                            <Star className="h-6 w-6 text-yellow-400" />
                            <span>Rated 4.9+ by Users</span>
                        </div>
                    </div>
                </div>
            </section>

            {/* Gallery Preview */}
            <section className="container mx-auto px-4 py-12">
                <h2 className="text-3xl font-bold text-center mb-8">Preview Our Collection</h2>
                <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
                    {[1, 2, 3, 4, 5, 6, 7, 8].map((id) => (
                        <div key={id} className="relative w-full aspect-[9/16] overflow-hidden rounded-lg shadow">
                            <Image
                                src={`https://picsum.photos/300/600?random=${id}`}
                                alt={`Wallpaper ${id}`}
                                fill
                                className="object-cover"
                            />
                        </div>
                    ))}
                </div>
            </section>

            {/* Footer */}
            <footer className="bg-white border-t border-gray-100 py-8 mt-8">
                <div className="container mx-auto px-4">
                    <div className="flex flex-col md:flex-row justify-between items-center">
                        <div className="flex items-center gap-2">
                            <div className="flex items-center gap-2">
                                <div className="h-10 w-10 rounded-xl overflow-hidden bg-white">
                                    <Image
                                        src="/logo.png"
                                        alt="App Logo"
                                        width={200}
                                        height={200}
                                        className="object-cover"
                                    />
                                </div>
                                <span className="font-medium text-lg text-gray-800">AppStore</span>
                            </div>
                        </div>
                        <div className="text-sm text-gray-500">
                            © {new Date().getFullYear()} Wallpaper App. All rights reserved.
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    )
}
