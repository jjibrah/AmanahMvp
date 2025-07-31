import { Palette, Heart } from "lucide-react";
import { AspectRatio } from "./ui/aspect-ratio";
const RiderAllySection = () => {
  return <div className="w-full px-4 md:px-8 lg:px-16 py-16 md:py-20 lg:py-28 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-start gap-12 md:gap-16 lg:gap-20">
        <div className="w-full flex flex-col lg:flex-row justify-start items-center gap-12 lg:gap-20">
          <div className="flex-1 flex flex-col justify-start items-start gap-6 md:gap-8">
            <div className="w-full flex flex-col justify-start items-start gap-6 md:gap-8">
              <div className="w-full flex flex-col justify-start items-start gap-4">
                <div className="h-6 px-2 bg-[#F0F4F7] rounded-[40px] border border-[#004746] flex justify-center items-center">
                  <div className="text-[#004746] text-sm font-poppins font-normal capitalize leading-[16.8px]">
                    For drivers
                  </div>
                </div>
                <div className="w-full flex flex-col justify-start items-start gap-2">
                  <div className="w-full text-[#004746] text-2xl md:text-4xl lg:text-5xl font-poppins font-medium capitalize leading-tight md:leading-[52.8px]">
                    Your Rider's Smartest Ally
                  </div>
                  <div className="w-full text-black text-sm md:text-base font-inter font-normal leading-5 md:leading-6">
                    Amanah's Driver App, every rider gets clear instructions, real-time delivery updates, route optimisation, and instant customer contact, all in one app.
                  </div>
                </div>
              </div>
              <div className="w-full py-2 flex flex-col sm:flex-row justify-center items-center gap-4 sm:gap-6">
                <div className="flex-1 flex flex-col justify-start items-center gap-4">
                  <div className="w-12 h-12 relative overflow-hidden rounded flex items-center justify-center">
                    <Palette className="w-9 h-10" style={{ color: '#004746' }} />
                  </div>
                  <div className="w-full text-black text-sm font-inter font-normal leading-[21px] text-center">
                    Customize tracking pages with your brand's logo and colors
                  </div>
                </div>
                <div className="flex-1 flex flex-col justify-start items-center gap-4">
                  <div className="w-12 h-12 relative overflow-hidden rounded flex items-center justify-center">
                    <Heart className="w-9 h-10" style={{ color: '#004746' }} />
                  </div>
                  <div className="w-full text-black text-sm font-inter font-normal leading-[21px] text-center">
                    Increase brand recall and customer loyalty
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div className="flex-1 w-full max-w-md lg:max-w-none">
            <AspectRatio ratio={3/4} className="w-full">
              <img 
                alt="Driver app interface" 
                src="/lovable-uploads/8f3843f4-358c-47cb-9f25-112287bd402f.png" 
                className="w-full h-full rounded-lg object-contain" 
              />
            </AspectRatio>
          </div>
        </div>
      </div>
    </div>;
};
export default RiderAllySection;