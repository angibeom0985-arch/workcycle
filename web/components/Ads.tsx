import React, { useEffect, useState, useRef } from "react";

const isMobile = () =>
  typeof window !== "undefined" && window.innerWidth <= 768;

const AdSlot: React.FC<{
  className?: string;
  style?: React.CSSProperties;
  children?: React.ReactNode;
}> = ({ className, style, children }) => {
  return (
    <div
      className={`ads-slot ${className || ""}`}
      style={style}
      aria-hidden="true"
    >
      {children}
    </div>
  );
};

const Ads: React.FC = () => {
  const [adblockDetected, setAdblockDetected] = useState(false);
  const [mobile, setMobile] = useState(isMobile());
  const adInitialized = useRef(false);

  useEffect(() => {
    const onResize = () => setMobile(isMobile());
    window.addEventListener("resize", onResize);
    return () => window.removeEventListener("resize", onResize);
  }, []);

  useEffect(() => {
    // Simple adblock detection: try to create an ins.adsbygoogle and check if window.adsbygoogle exists
    const test = document.createElement("div");
    test.className = "adsbygoogle";
    test.style.display = "block";
    document.body.appendChild(test);

    // If after a short timeout adsbygoogle or the test element is hidden/removed, assume adblock
    setTimeout(() => {
      const computed = window.getComputedStyle(test);
      const hidden =
        computed &&
        (computed.display === "none" ||
          computed.visibility === "hidden" ||
          test.offsetParent === null);
      const noGlobal = typeof (window as any).adsbygoogle === "undefined";
      if (hidden || noGlobal) setAdblockDetected(true);
      try {
        document.body.removeChild(test);
      } catch (e) {}
    }, 100);
  }, []);

  useEffect(() => {
    // Initialize ads after component mounts (only once)
    if (!adblockDetected && !adInitialized.current) {
      adInitialized.current = true;
      try {
        ((window as any).adsbygoogle = (window as any).adsbygoogle || []).push(
          {}
        );
      } catch (e) {
        console.error("AdSense error:", e);
      }
    }
  }, [adblockDetected]);

  if (adblockDetected) {
    return (
      <div
        id="adblock-overlay"
        className="fixed inset-0 z-50 flex items-center justify-center bg-white/95 p-6"
      >
        <div className="max-w-lg text-center">
          <h2 className="text-2xl font-bold mb-4">
            광고 차단 프로그램이 감지되었습니다
          </h2>
          <p className="mb-4">
            이 사이트는 광고를 통해 운영됩니다. 광고 차단 프로그램을 비활성화한
            뒤 페이지를 새로고침 해주세요.
          </p>
          <button
            onClick={() => location.reload()}
            className="px-4 py-2 bg-blue-600 text-white rounded"
          >
            비활성화 후 새로고침
          </button>
        </div>
      </div>
    );
  }

  return (
    <>
      {/* Bottom anchor ad (mobile + desktop) */}
      <div className="anchor-ad fixed left-0 right-0 bottom-0 z-40 flex items-center justify-center pointer-events-auto">
        <div className="w-full flex items-center justify-center">
          <ins
            className="adsbygoogle"
            style={{
              display: "block",
              width: "100%",
              height: mobile ? "50px" : "60px",
            }}
            data-ad-client="ca-pub-2686975437928535"
            data-ad-slot="4510733526"
            data-ad-format="auto"
            data-full-width-responsive="true"
          ></ins>
        </div>
      </div>
    </>
  );
};

export default Ads;
