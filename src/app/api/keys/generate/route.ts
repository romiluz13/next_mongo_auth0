import { getSession } from '@auth0/nextjs-auth0';
import { NextResponse } from 'next/server';
import { ApiKey } from '@/lib/models/ApiKey';
import connectDB from '@/lib/mongodb';

export async function POST(req: Request) {
  try {
    const session = await getSession();
    if (!session?.user) {
      return NextResponse.json({ error: 'Not authenticated' }, { status: 401 });
    }

    const { name } = await req.json();
    if (!name) {
      return NextResponse.json({ error: 'Name is required' }, { status: 400 });
    }

    await connectDB();
    
    // Generate new API key
    const { key, hashedKey } = ApiKey.generateKey();

    // Create new API key record
    await ApiKey.create({
      userId: session.user.sub,
      name,
      key,
      hashedKey,
    });

    return NextResponse.json({ key });
  } catch (error) {
    console.error('Error generating API key:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
} 