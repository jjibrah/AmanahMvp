import { useRef } from "react";
import { useScrollEffect } from "../hooks/useScrollEffect";

const LargeTextSection = () => {
  const firstTextRef = useRef<HTMLDivElement>(null);
  const secondTextRef = useRef<HTMLDivElement>(null);
  const firstScrollProgress = useScrollEffect(firstTextRef);
  const secondScrollProgress = useScrollEffect(secondTextRef);
  
  // Interpolate between light gray (#CCCCCC) and darker target color (#002726)
  const getTextColor = (progress: number) => {
    // Starting color: #CCCCCC (light gray)
    const startR = 0xCC;
    const startG = 0xCC;
    const startB = 0xCC;
    
    // Target color: #002726 (darker green for better visibility)
    const endR = 0x00;
    const endG = 0x27;
    const endB = 0x26;
    
    // Interpolate
    const r = Math.round(startR + (endR - startR) * progress);
    const g = Math.round(startG + (endG - startG) * progress);
    const b = Math.round(startB + (endB - startB) * progress);
    
    return `rgb(${r}, ${g}, ${b})`;
  };

  // Subtle letter spacing for tracking effect without scaling
  const getLetterSpacing = (progress: number) => {
    // Very subtle tracking change (0.01em to 0em) - barely noticeable scaling
    const startTracking = 0.01;
    const endTracking = 0;
    const currentTracking = startTracking + (endTracking - startTracking) * progress;
    return `${currentTracking}em`;
  };

  return (
    <div className="w-full px-4 md:px-8 lg:px-16 pt-16 md:pt-24 lg:pt-32 pb-16 md:pb-24 lg:pb-32 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
        <div className="w-full max-w-[1024px] flex flex-col justify-start items-start gap-8 md:gap-12">
          <div className="w-full flex flex-col justify-start items-start gap-6 md:gap-8">
            <div 
              ref={firstTextRef}
              className="w-full text-2xl md:text-4xl lg:text-[60px] font-poppins font-medium capitalize leading-tight md:leading-[44px] lg:leading-[66px] break-words transition-all duration-300 ease-out"
              style={{ 
                color: getTextColor(firstScrollProgress),
                letterSpacing: getLetterSpacing(firstScrollProgress)
              }}
            >
              Amanah simplifies the delivery process for local businesses, ensuring timely and efficient service.
            </div>
            
            <div 
              ref={secondTextRef}
              className="w-full text-2xl md:text-4xl lg:text-[60px] font-poppins font-medium capitalize leading-tight md:leading-[44px] lg:leading-[66px] break-words transition-all duration-300 ease-out mt-8 md:mt-12"
              style={{ 
                color: getTextColor(secondScrollProgress),
                letterSpacing: getLetterSpacing(secondScrollProgress)
              }}
            >
              With Amanah's Smart Dispatch, automatically assign the nearest available rider to each delivery, reducing delays, maximising fleet utilisation, and boosting customer satisfaction.
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default LargeTextSection;
