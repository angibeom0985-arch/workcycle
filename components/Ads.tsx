import React, { useEffect, useState } from "react";

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
    // Initialize ads after component mounts
    if (!adblockDetected) {
      try {
        ((window as any).adsbygoogle = (window as any).adsbygoogle || []).push(
          {}
        );
      } catch (e) {
        console.error("AdSense error:", e);
      }
    }
  }, [adblockDetected, mobile]);

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
      {/* Left and right vertical ads (desktop only) */}
      {!mobile && (
        <>
          <AdSlot className="left-vertical fixed left-0 top-0 h-full w-24 md:w-32 lg:w-44 flex items-center justify-center p-2 pointer-events-none">
            <div style={{ width: "120px" }}>
              {/* Placeholder vertical ad - replace with actual ad markup if needed */}
              <ins
                className="adsbygoogle"
                style={{ display: "block", width: "120px", height: "600px" }}
                data-ad-client="ca-pub-2686975437928535"
                data-ad-slot="4510733526"
                data-ad-format="auto"
                data-full-width-responsive="false"
              ></ins>
            </div>
          </AdSlot>
          <AdSlot className="right-vertical fixed right-0 top-0 h-full w-24 md:w-32 lg:w-44 flex items-center justify-center p-2 pointer-events-none">
            <div style={{ width: "120px" }}>
              <ins
                className="adsbygoogle"
                style={{ display: "block", width: "120px", height: "600px" }}
                data-ad-client="ca-pub-2686975437928535"
                data-ad-slot="4510733526"
                data-ad-format="auto"
                data-full-width-responsive="false"
              ></ins>
            </div>
          </AdSlot>
        </>
      )}

      {/* Bottom anchor ad (mobile + desktop) */}
      <div className="anchor-ad fixed left-0 right-0 bottom-0 z-40 flex items-center justify-center p-2 pointer-events-auto">
        <div className="w-full flex items-center justify-center">
          <ins
            className="adsbygoogle"
            style={{
              display: "block",
              width: mobile ? "320px" : "728px",
              height: mobile ? "50px" : "90px",
            }}
            data-ad-client="ca-pub-2686975437928535"
            data-ad-slot="4510733526"
            data-ad-format="auto"
            data-full-width-responsive="false"
          ></ins>
        </div>
      </div>
    </>
  );
};

export default Ads;
