
import { useRef } from "react";

const HeroSection = () => {
  return (
    <div className="w-full px-4 md:px-8 lg:px-16 py-16 md:py-20 lg:py-28 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
        <div className="w-full max-w-[768px] flex flex-col justify-start items-center gap-6 md:gap-8">
          <div className="w-full flex flex-col justify-start items-center gap-4 md:gap-6">
            <h1 className="w-full text-center text-[#004746] text-3xl md:text-5xl lg:text-[72px] font-poppins font-medium capitalize leading-tight md:leading-[52.8px] lg:leading-[79.2px] break-words">
              your silent partner for flawless deliveries
            </h1>
            <p className="w-full text-center text-black text-sm md:text-base font-inter font-normal leading-5 md:leading-6 break-words px-4 md:px-0">
              Amanah puts you in complete control of your delivery operations. Automate rider assignment, track every delivery in real-time, and provide exceptional customer experiences effortlessly.
            </p>
          </div>
          <div className="flex flex-col sm:flex-row justify-center items-center gap-3 md:gap-4 w-full sm:w-auto">
            <a 
              href="https://form.typeform.com/to/mNUPuF4g" 
              target="_blank" 
              rel="noopener noreferrer"
              className="w-full sm:w-auto px-4 md:px-6 py-2.5 md:py-3 bg-[#004746] rounded-xl flex justify-center items-center gap-2 hover:bg-[#003635] transition-colors"
            >
              <span className="text-white text-sm md:text-base font-poppins font-medium leading-[19.2px]">
                Get Started
              </span>
            </a>
            <a 
              href="https://form.typeform.com/to/mNUPuF4g" 
              target="_blank" 
              rel="noopener noreferrer"
              className="w-full sm:w-auto px-4 md:px-6 py-2.5 md:py-3 rounded-xl border border-[#004746] flex justify-center items-center gap-2 hover:bg-gray-50 transition-colors"
            >
              <span className="text-[#004746] text-sm md:text-base font-poppins font-medium leading-[19.2px]">
                Book a live demo
              </span>
            </a>
          </div>
        </div>
        <img className="w-full h-48 md:h-96 lg:h-[720px] rounded-xl shadow-[0px_1px_3px_rgba(0,0,0,0.30)] object-cover" alt="Hero image" src="/lovable-uploads/d4f7fe16-b3ec-41ca-ab96-9bb846c9e902.png" />
      </div>
    </div>
  );
};

export default HeroSection;
