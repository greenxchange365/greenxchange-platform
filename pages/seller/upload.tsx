// pages/seller/upload.tsx
import { useState } from 'react';
import { supabase } from '../../lib/supabaseClient';

export default function SellerUpload() {
  const [file, setFile] = useState<File | null>(null);
  const [message, setMessage] = useState("");
  const [uploading, setUploading] = useState(false);

  async function uploadFile(e: any) {
    e.preventDefault();
    if (!file) {
      setMessage("Please select a file");
      return;
    }

    // Get logged in user
    const { data: { session } } = await supabase.auth.getSession();
    if (!session) {
      setMessage("Please login first");
      return;
    }

    const userId = session.user.id;
    const filename = Date.now() + "_" + file.name;
    const path = `projects/uploads/${userId}/${filename}`;

    setUploading(true);

    const { data, error } = await supabase.storage
      .from("Documents")
      .upload(path, file);

    setUploading(false);

    if (error) {
      setMessage("Upload failed: " + error.message);
    } else {
      setMessage("Uploaded successfully to: " + data.path);
    }
  }

  return (
    <div style={{ maxWidth: 800, margin: "50px auto", fontFamily: "Arial" }}>
      <h2>Upload Your Document</h2>
      <form onSubmit={uploadFile}>
        <input type="file" onChange={(e) => setFile(e.target.files?.[0] || null)} />
        <br /><br />
        <button type="submit" disabled={uploading}>
          {uploading ? "Uploading..." : "Upload File"}
        </button>
      </form>
      <p style={{ marginTop: "20px", color: "#333" }}>{message}</p>
    </div>
  );
}
