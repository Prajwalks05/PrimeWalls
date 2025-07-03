'use client';

import React from 'react';
import useEmblaCarousel from 'embla-carousel-react';
import Image from 'next/image';

export default function PortraitCarousel({ screenshots }) {
  const [emblaRef, emblaApi] = useEmblaCarousel({ loop: true });

  return (
    <section className="bg-white py-16">
      <div className="container mx-auto px-8">
        <h2 className="text-3xl font-bold text-center mb-8">Mobile Screenshots</h2>
        <div className="relative">
          <div className="overflow-hidden" ref={emblaRef}>
            <div className="flex">
              {screenshots.map((src, index) => (
                <div key={index} className="flex-none w-[350px] h-[750px] mr-4">
                  <div className="relative w-full h-full rounded-lg overflow-hidden shadow-lg">
                    <Image
                      src={src}
                      alt={`Portrait Screenshot ${index + 1}`}
                      fill
                      className="object-cover"
                    />
                  </div>
                </div>
              ))}
            </div>
          </div>

          <div className="flex justify-center mt-4 gap-4">
            <button
              className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded"
              onClick={() => emblaApi?.scrollPrev()}
            >
              ◀
            </button>
            <button
              className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded"
              onClick={() => emblaApi?.scrollNext()}
            >
              ▶
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
