---
title: "A Program that Ends Before it Starts"
date: 2026-05-30T08:59:29-04:00
---

### Impossible Programs - A Program that Ends Before it Starts

<img src="/images/posts/alicethroughtheglass.jpg" alt="Alice Through the Looking Glass" style="display: block; max-width: 50%; height: auto; margin: 0 auto 24px;" />

>Alice laughed. “There’s no use trying,” she said: “one can’t believe impossible things.”
>
>“I daresay you haven’t had much practice,” said the Queen. “When I was your age, I always did it for half-an-hour a day. Why, sometimes I’ve believed as many as six impossible things before breakfast. There goes the shawl again!”
>
> [Through the Looking Glass by Lewis Carrol](https://www.gutenberg.org/files/12/12-h/12-h.htm)

It is early in the morning. The house is quiet. The birds outside are just beginning to call to each other in the new light. I take a sip of coffee and decide to tackle my first impossible thing of the day.


Let’s make a program that ends before it starts.


First, we will need to think about what a program is. For our purposes, let us assume that it is some bit of deterministic code that is executed at a start time (t0), with an initial state (s0), and it will complete at an end time (t1), with a final state (s1).


*t0,s0 -> t1,s1*


Let’s focus on the time part …

If we made the time really small - like quantum [Heisenberg Uncertainty](https://en.wikipedia.org/wiki/Uncertainty_principle)  small, we could have the possibility of t1 being smaller than t0.

No. I always get pretty confused on the quantum level and it always feels like cheating to just declare, Quantum!

Moving on.

We could make each time have a different representation. For example, we could turn t0 into a multi-dimensional vector embedding. One that could be an array of thousands of binary values. If we do the same with t1, we can have complete control of the definition of the relationship and we could define ….

Yeah no, let’s move on.

We could have the same program running on different machines, whose processes have a different clock speed. One could definitely run before the other one - not really interesting though. Let’s stay on the same computing platform and assume the exact same machine that would run the exact same way. However, that same machine could be located in a different physical place than the other one. Maybe a bit higher up where I am sitting right now …

If we think about time itself, it is not the same everywhere thanks to the [Time Dilation Effect](https://en.wikipedia.org/wiki/Time_dilation). Time passes ever so slightly slower for me sitting in my kitchen in Cincinnati, Ohio then it does for someone sitting on top of Mt Everest. Even more so for someone sitting on top of a satellite in geo synchronous orbit. In fact after 100 years the time difference would be:


- On Mt Everest ~ 2.3 ms (faster than Cincinnati)
 - On Satellite ~ 1.7 s (faster than Cincinnati)

In theory, we could kick off the same programs running at the same time where I am sitting, Mt Everest, and in the satellite. If the program is long enough for it to have enough time dilation shift from my perspective AND send a message back, it could give me the answer to my program here before it ends!!!

We still haven’t made a program that ends before it starts, but we have made a thought experiment **program that ends before it ends**!

Like many things, it was more about the journey than the destination. It's a lot of fun thinking about the impossible.

I’ll leave the other 5 impossible things for the rest of the morning to you :) 

#### AI Disclaimer
_All the crazy ideas and prose are mine. I did have Claude help me with the math and a D3 visualization of the time dilation, which you can view if you choose to expand._


<details style="border: 1px solid rgba(168,85,247,0.4); border-radius: 12px; padding: 14px 18px; margin: 28px 0; background: rgba(168,85,247,0.06);">
  <summary style="cursor: pointer; font-weight: 600; color: #a855f7; padding: 6px 0; user-select: none;">
    🐄 Expand for visualization
    <span style="opacity: 0.65; font-weight: normal; font-size: 0.9em;">— D3 visualization of Time Dialation Programs</span>
  </summary>
  <iframe
    src="/visualizations/time-dilation/"
    width="100%"
    height="1400"
    style="border: 0; border-radius: 8px; background: #0a0e27; margin-top: 16px;"
    loading="lazy"
    title="Time dilation visualization">
  </iframe>
</details>
