"use client"

import { useState } from "react"
import Image from "next/image"
import Link from "next/link"
import Head from 'next/head';
import { ChevronLeft, ChevronRight, Download, Star } from "lucide-react"
import { Button } from "@/components/ui/button"
import { Card, CardContent } from "@/components/ui/card"
import 'aos/dist/aos.css';
<head></head>
export default function AppShowcase() {
  const [currentImageIndex, setCurrentImageIndex] = useState(0)

  const appScreenshots = [
    "/screenshots/login.jpg?1",
    "/screenshots/search.jpg?2",
    "/screenshots/favourite.jpeg?3",
    "/screenshots/profile.jpg?4",
  ]

  const nextImage = () => {
    setCurrentImageIndex((prevIndex) => (prevIndex === appScreenshots.length - 1 ? 0 : prevIndex + 1))
  }

  const prevImage = () => {
    setCurrentImageIndex((prevIndex) => (prevIndex === 0 ? appScreenshots.length - 1 : prevIndex - 1))
  }

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
                <Link href="/about" className="font-medium text-gray-600 hover:text-gray-900">
                  About
                </Link>
              </li>
            </ul>

          </nav>
        </div>
      </header>

      {/* Hero Section */}
      <section className="container mx-auto px-4 py-12 md:py-20">
        <div className="grid md:grid-cols-2 gap-12 items-center">
          <div>
            <h1 className="text-4xl md:text-5xl font-bold tracking-tight text-gray-900 mb-6">Primewalls</h1>
            <div className="flex items-center gap-1 mb-4">
              {Array(5).fill(null).map((_, i) => (
                <Star key={i} className="h-5 w-5 fill-yellow-400 text-yellow-400" />
              ))}
              <span className="ml-2 text-sm text-gray-600">5.0 (1.2k Reviews)</span>
            </div>
            <p className="text-lg text-gray-600 mb-8">
              Experience the next generation of mobile applications with our innovative solution. Designed with user
              experience in mind, our app delivers exceptional performance and stunning visuals.
            </p>
            <div className="flex flex-col sm:flex-row gap-4">
              <a href="https://drive.google.com/file/d/1HIhyqHv-Jmfz41wdjw1QlQA7X-zHtN7g/view" target="_blank" rel="noopener noreferrer">
                <Button className="bg-gradient-to-r from-blue-600 to-blue-700 hover:from-blue-700 hover:to-blue-800"
                >Download APK</Button>
              </a>
            </div>
          </div>
          <div className="flex justify-center">
            <div className="relative w-[300px] h-[600px] bg-black rounded-[40px] p-3 border-[8px] border-gray-800 shadow-2xl">
              <div className="absolute top-0 left-1/2 transform -translate-x-1/2 w-1/3 h-6 bg-black rounded-b-xl z-10"></div>
              <div className="w-full h-full overflow-hidden rounded-[32px] relative">
                <Image
                  src="/homescreen.jpg"
                  alt="App Logo"
                  fill
                  className="object-cover"
                />
              </div>
            </div>
          </div>
        </div>
      </section >

      {/* Screenshot Carousel */}
      < section className="bg-gray-50 py-16" >
        <div className="container mx-auto px-4">
          <h2 className="text-3xl font-bold text-center mb-12">App Screenshots</h2>
          <div className="relative max-w-5xl mx-auto">
            <Button
              variant="ghost"
              size="icon"
              className="absolute left-0 top-1/2 -translate-y-1/2 z-10 bg-white/80 hover:bg-white shadow-lg rounded-full h-12 w-12"
              onClick={prevImage}
            >
              <ChevronLeft className="h-6 w-6" />
            </Button>

            <div className="overflow-hidden">
              <div className="flex gap-4 justify-center">
                {appScreenshots.map((screenshot, index) => (
                  <Card
                    key={index}
                    className={`transition-all duration-300 ${index === currentImageIndex ? "scale-100 opacity-100" : "scale-90 opacity-50 hidden md:block"
                      }`}
                  >
                    <CardContent>
                      <div className="relative w-[200px] h-[400px] overflow-hidden rounded-lg">
                        <Image
                          src={screenshot}
                          alt={`App screenshot ${index + 1}`}
                          fill
                          className="object-cover"
                        />
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </div>

            <Button
              variant="ghost"
              size="icon"
              className="absolute right-0 top-1/2 -translate-y-1/2 z-10 bg-white/80 hover:bg-white shadow-lg rounded-full h-12 w-12"
              onClick={nextImage}
            >
              <ChevronRight className="h-6 w-6" />
            </Button>
          </div>

          <div className="flex justify-center mt-8 gap-2">
            {appScreenshots.map((_, index) => (
              <button
                key={index}
                className={`w-3 h-3 rounded-full ${index === currentImageIndex ? "bg-blue-600" : "bg-gray-300"}`}
                onClick={() => setCurrentImageIndex(index)}
              />
            ))}
          </div>
        </div>
      </section >

      {/* Features Section */}
      < section className="container mx-auto px-4 py-16" >
        <h2 className="text-3xl font-bold text-center mb-12">Key Features</h2>
        <div className="grid md:grid-cols-3 gap-8">
          {/* Feature Cards */}
          {/* ... Keep your features here as-is, unchanged ... */}
        </div>
      </section >

      {/* Download Section */}
      < section className="bg-gradient-to-r from-gray-100 to-gray-200 py-16" >
        <div className="container mx-auto px-4 text-center">
          <div className="flex justify-center mb-6">
            <div className="h-24 w-24 rounded-xl bg-gradient-to-br from-blue-500 to-purple-600 flex items-center justify-center text-white font-bold text-4xl shadow-lg">
              A
            </div>
          </div>
          <h2 className="text-3xl font-bold mb-4">Ready to Experience the App?</h2>
          <p className="text-lg text-gray-600 max-w-2xl mx-auto mb-8">
            Download our app now and join thousands of satisfied users who have transformed their mobile experience.
          </p>
        </div>
      </section >

      {/* Footer */}
      < footer className="bg-white border-t border-gray-100 py-8" >
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
              © {new Date().getFullYear()} Primewalls @2025. All rights reserved.
            </div>
          </div>
        </div>
      </footer >
    </div >
  )
}
