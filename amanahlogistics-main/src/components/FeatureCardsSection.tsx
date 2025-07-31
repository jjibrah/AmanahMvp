
const FeatureCardsSection = () => {
  return (
    <div id="features" className="w-full px-4 md:px-8 lg:px-16 py-16 md:py-20 lg:py-28 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
        <div className="w-full flex flex-col justify-start items-start gap-8">
          <div className="w-full flex flex-col justify-start items-start gap-8">
            {/* Main Feature Card */}
            <div className="w-full h-[536px] bg-gradient-to-br from-[#C6FDC6] via-[#DFFEDF] to-[#F2FFF2] overflow-hidden rounded-xl flex flex-col lg:flex-row justify-start items-start">
              <div className="w-full lg:w-[640px] self-stretch p-6 flex flex-col justify-center items-start gap-6">
                <div className="w-full flex flex-col justify-start items-start gap-2">
                  <div className="w-full flex flex-col justify-start items-start gap-2">
                    <div className="w-full text-black text-2xl md:text-3xl lg:text-4xl font-poppins font-medium capitalize leading-tight">
                      Your Personal Brand Ambassador
                    </div>
                    <div className="w-full text-black text-sm md:text-base font-inter font-normal leading-6">
                      Think of Amanah as your dedicated ambassador, ensuring your brand stays front and center with every delivery. It proudly showcases your identity, builds lasting impressions, and turns every delivery into an opportunity for customer loyalty.
                    </div>
                  </div>
                </div>
              </div>
              <div className="w-full lg:w-[640px] self-stretch rounded-xl flex flex-col justify-center items-end relative">
                <iframe 
                  src="https://lottie.host/embed/addca3a4-6b9b-4090-b483-f27293faa4e8/uQ7QibqbIS.lottie" 
                  className="w-full flex-1 rounded-xl"
                  style={{ border: 'none', minHeight: '300px' }}
                  title="Brand Ambassador Lottie Animation"
                  loading="lazy"
                  allowFullScreen
                  referrerPolicy="no-referrer-when-downgrade"
                  onError={(e) => {
                    console.log('Lottie iframe failed to load:', e);
                    const target = e.target as HTMLElement;
                    const fallback = document.createElement('div');
                    fallback.className = 'w-full flex-1 rounded-xl bg-gray-100 flex items-center justify-center';
                    fallback.innerHTML = '<div class="text-gray-500 text-center"><div class="text-2xl mb-2">🚚</div><div>Brand Ambassador Animation</div></div>';
                    target.parentNode?.replaceChild(fallback, target);
                  }}
                />
              </div>
            </div>
            
            {/* Two Column Feature Cards */}
            <div className="w-full flex flex-col lg:flex-row justify-start items-center gap-4">
              {/* First Feature Card */}
              <div className="w-full lg:w-[632px] h-[574px] bg-gradient-to-br from-[#86E9DD] to-[#F0FFFD] overflow-hidden rounded-xl flex flex-col justify-start items-start">
                <div className="w-full flex-1 p-6 flex flex-col justify-center items-start gap-6">
                  <div className="w-full flex flex-col justify-start items-start gap-2">
                    <div className="w-full flex flex-col justify-start items-start gap-2">
                      <div className="w-full text-black text-xl md:text-2xl lg:text-4xl font-poppins font-medium capitalize leading-tight">
                        Real-time delivery tracking
                      </div>
                      <div className="w-full text-black text-sm md:text-base font-inter font-normal leading-6">
                        Amanah provides real-time delivery tracking for your customers, significantly reducing queries and enhancing trust and transparency.
                      </div>
                    </div>
                  </div>
                </div>
                <div className="w-full flex-1 rounded-xl flex flex-col justify-end items-center relative">
                  <iframe 
                    src="https://lottie.host/embed/17a96bf1-c932-413a-9c59-ccf780a9d94a/FSqyFXLd6r.lottie" 
                    className="w-full flex-1 rounded-xl"
                    style={{ border: 'none', minHeight: '400px' }}
                    title="Real-time Tracking Lottie Animation"
                    loading="lazy"
                    allowFullScreen
                    referrerPolicy="no-referrer-when-downgrade"
                    onError={(e) => {
                      console.log('Real-time tracking Lottie iframe failed to load:', e);
                      const target = e.target as HTMLElement;
                      const fallback = document.createElement('div');
                      fallback.className = 'w-full flex-1 rounded-xl bg-gray-100 flex items-center justify-center';
                      fallback.innerHTML = '<div class="text-gray-500 text-center"><div class="text-4xl mb-4">📍</div><div class="text-lg font-medium">Real-time Tracking</div></div>';
                      target.parentNode?.replaceChild(fallback, target);
                    }}
                  />
                </div>
              </div>
              
              {/* Second Feature Card */}
              <div className="w-full lg:w-[632px] h-[574px] bg-gradient-to-br from-[#ADFAAD] via-[#CDFDCD] to-[#F2FFF2] overflow-hidden rounded-xl flex flex-col justify-start items-start">
                <div className="w-full flex-none p-6 flex flex-col justify-center items-start gap-6">
                  <div className="w-full flex flex-col justify-start items-start gap-2">
                    <div className="w-full flex flex-col justify-start items-start gap-2">
                      <div className="w-full text-black text-xl md:text-2xl lg:text-4xl font-poppins font-medium capitalize leading-tight">
                        Analytics Dashboard
                      </div>
                      <div className="w-full text-black text-sm md:text-base font-inter font-normal leading-6">
                        Amanah's comprehensive analytics dashboard provides actionable insights into your delivery performance, helping you make informed decisions to optimize operations.
                      </div>
                    </div>
                  </div>
                </div>
                <div className="w-full flex-1 rounded-xl flex flex-col justify-end items-center relative">
                  <iframe 
                    src="https://lottie.host/embed/4a80c985-827e-4df6-ac9a-5cf973356629/HwotjNoIzF.lottie" 
                    className="w-full flex-1 rounded-xl"
                    style={{ border: 'none', minHeight: '400px' }}
                    title="Analytics Dashboard Lottie Animation"
                    loading="lazy"
                    allowFullScreen
                    referrerPolicy="no-referrer-when-downgrade"
                    onError={(e) => {
                      console.log('Analytics Lottie iframe failed to load:', e);
                      const target = e.target as HTMLElement;
                      const fallback = document.createElement('div');
                      fallback.className = 'w-full flex-1 rounded-xl bg-gray-100 flex items-center justify-center';
                      fallback.innerHTML = '<div class="text-gray-500 text-center"><div class="text-4xl mb-4">📊</div><div class="text-lg font-medium">Analytics Dashboard</div><div class="text-sm">Interactive Charts & Insights</div></div>';
                      target.parentNode?.replaceChild(fallback, target);
                    }}
                  />
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FeatureCardsSection;
