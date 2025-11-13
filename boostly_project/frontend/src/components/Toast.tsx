import React from 'react';
export default function Toast({message}:{message:string}) {
  if (!message) return null;
  return (
    <div aria-live="polite" role="status" className="fixed bottom-6 right-6 bg-black text-white px-4 py-2 rounded-md shadow">
      {message}
    </div>
  );
}
