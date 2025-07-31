
const LogoListSection = () => {
  // Kenyan company logos data
  const kenyanLogos = [
    { name: "Safaricom", image: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=200&h=56&fit=crop" },
    { name: "Equity Bank", image: "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=200&h=56&fit=crop" },
    { name: "KCB Bank", image: "https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=200&h=56&fit=crop" },
    { name: "Tusker", image: "https://images.unsplash.com/photo-1608270586620-248524c67de9?w=200&h=56&fit=crop" },
    { name: "Nation Media", image: "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=200&h=56&fit=crop" },
    { name: "Airtel Kenya", image: "https://images.unsplash.com/photo-1611605698335-8b1569810432?w=200&h=56&fit=crop" },
    { name: "Co-op Bank", image: "https://images.unsplash.com/photo-1541354329998-f4d9a9f9297f?w=200&h=56&fit=crop" },
  ];

  return (
    <div className="w-full py-20 bg-white overflow-hidden flex flex-col justify-start items-center gap-12">
      <div className="w-full px-16 flex justify-center items-center gap-2">
        <div className="w-full max-w-[560px] text-center text-black text-xl font-poppins font-semibold leading-7">
          Used by the most forward thinking businesses
        </div>
      </div>
      <div className="w-full flex flex-col justify-start items-center">
        <div className="relative w-full overflow-hidden">
          <div className="flex animate-scroll-left gap-6">
            {/* First set of logos */}
            {kenyanLogos.map((logo, index) => (
              <div key={`first-${index}`} className="w-[200px] h-14 relative overflow-hidden bg-white rounded-lg flex items-center justify-center shadow-sm border border-gray-100 flex-shrink-0">
                <img 
                  src={logo.image} 
                  alt={logo.name}
                  className="w-full h-full object-contain p-2 grayscale hover:grayscale-0 transition-all duration-300"
                  onError={(e) => {
                    const target = e.target as HTMLImageElement;
                    target.style.display = 'none';
                    const fallback = document.createElement('div');
                    fallback.className = 'w-[133px] h-6 bg-gray-300 rounded flex items-center justify-center text-xs text-gray-600';
                    fallback.textContent = logo.name;
                    target.parentNode?.appendChild(fallback);
                  }}
                />
              </div>
            ))}
            {/* Duplicate set for seamless loop */}
            {kenyanLogos.map((logo, index) => (
              <div key={`second-${index}`} className="w-[200px] h-14 relative overflow-hidden bg-white rounded-lg flex items-center justify-center shadow-sm border border-gray-100 flex-shrink-0">
                <img 
                  src={logo.image} 
                  alt={logo.name}
                  className="w-full h-full object-contain p-2 grayscale hover:grayscale-0 transition-all duration-300"
                  onError={(e) => {
                    const target = e.target as HTMLImageElement;
                    target.style.display = 'none';
                    const fallback = document.createElement('div');
                    fallback.className = 'w-[133px] h-6 bg-gray-300 rounded flex items-center justify-center text-xs text-gray-600';
                    fallback.textContent = logo.name;
                    target.parentNode?.appendChild(fallback);
                  }}
                />
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default LogoListSection;
